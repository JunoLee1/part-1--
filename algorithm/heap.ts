console.log("hi");
type Comparator<T> = (a: T, b: T) => number;

export class Heap<T> {
  heap: T[] = [];
  comparator: Comparator<T>;
  constructor(comparator: Comparator<T>, arr : T[] = []) {
    this.heap = arr
    this.comparator = comparator;
  }
  swap(i: number, j: number): void {
    [this.heap[i], this.heap[j]] = [this.heap[j], this.heap[i]];
  }
  buildHeap():void{ // time complexity O(n)
    const n = this.heap.length
    for (let i = Math.floor(n / 2) - 1; i >= 0 ; i--){
      this.heapifyDown(i,n)
    }
  }
  insert(value: T): void {
    console.log("value", value);
    this.heap.push(value);
    this.heapifyUp();
    console.log(this.heap);
  }
  pop(n:number): T | undefined {
    const end = n - 1
    this.swap(0, end);
    const res = this.heap.pop()!;
    this.heapifyDown(end,n);
    return res;
  }

  heapifyUp() {
    let idx = this.heap.length - 1;

    while (idx > 0) {
      const parentIdx = Math.floor((idx - 1) / 2);
      if (this.comparator(this.heap[parentIdx], this.heap[idx]) < 0) break;
      this.swap(parentIdx, idx);
      idx = parentIdx;
    }
  }
  heapifyDown(i: number, n: number): void {
    while (2 * i + 1 > 0 && 2 * i + 1 < n) {
      let leftChild: number = 2 * i + 1;
      let rightChild: number = 2 * i + 2;
      let smallestChildIdx = leftChild;
      if (
        rightChild < n &&
        this.comparator(this.heap[rightChild], this.heap[leftChild]) < 0
      ) {
        smallestChildIdx = rightChild;
      }
      if (this.comparator(this.heap[i], this.heap[smallestChildIdx]) < 0) break;
      this.swap(i, smallestChildIdx);
      i = smallestChildIdx;
    }
  }
  sort():T[]{
    const n = this.heap.length - 1
    this.buildHeap()
    for(let end = n - 1;end > 0; end--){
      this.swap(0, end)
      this.heapifyDown(0 ,end)
    }
    return this.heap
  }
}

const minHeap = new Heap<number>((a, b) => a - b); 
minHeap.insert(10);
minHeap.insert(9);
minHeap.insert(18);
minHeap.insert(1);

const maxHeap = new Heap<number>((a, b) => b - a);
maxHeap.insert(10);
maxHeap.insert(9);
maxHeap.insert(18);
maxHeap.insert(1);
console.log(maxHeap);

const PQ = new Heap<number>((a, b) => b - a, [1, 2, 9, 9]);
const res = []
while( PQ.heap.length > 0){
  const el = PQ.heap.pop()
  res.push(el)
}
console.log(res)

// why Time complexity is n log n
// insert (n times) * heapify up and down (log n) 

// 2^h <= n <= 2^(h + 1)
// h <= log n <= h + 1fhrh

// h = log n