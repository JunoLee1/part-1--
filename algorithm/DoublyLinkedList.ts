interface DoublyListNode {
  val: string;
  next: DoublyListNode | null;
  prev: DoublyListNode | null;
}

class DoublyLinkedList {
  head: DoublyListNode | null;
  tail: DoublyListNode | null;
  constructor() {
    ((this.head = null), (this.tail = null));
  }
  append(value: string) {
    // append head and taill
    //let prev = this.head;
    const newNode: DoublyListNode | null = {
      val: value,
      prev: null,
      next: null,
    };
    if (!this.head) {
      this.head = newNode;
      this.tail = newNode;
      return;
    } else {
      newNode.prev = this.tail;
      this.tail!.next = newNode;
      this.tail = newNode;
    }
    return this.head
  }
  insert(targetValue: string, value: string) {
    // insert after
    const newNode: DoublyListNode | null = {
      val: value,
      prev: null,
      next: null,
    };
    if (!this.head) {
      this.head = newNode;
      this.tail = newNode;
    }
    let previous = this.head;
    while (previous && previous.next) {
      if (previous.val === targetValue) {
        newNode.next = previous;
        newNode.prev = previous.next;
        if (previous.next) {
          previous.next.prev = newNode;
        } else {
          this.tail = newNode;
        }
        previous.next = newNode;
        return;
      }
      previous = previous.next;
    }
    return previous
  }
  findNode(value: string) {
    let prev: DoublyListNode | null = this.head;

    while (prev) {
      if (prev.val !== value) {
        prev = prev.next;
      } else {
        return prev.val;
      }
    }
    return ;
  }
}
