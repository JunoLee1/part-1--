interface ListNode {
  val: string;
  next: ListNode | null;
}
class SinglyLinkedListTs {
  head: ListNode | null;
  tail: ListNode | null;
  constructor() {
    ((this.head = null), (this.tail = null));
  }

  append(value: string) {
    let newNode: ListNode = { val: value, next: null };

    if (this.head === null) {
      this.head = newNode;
      this.tail = newNode;
      return;
    } else {
      this.tail!.next = newNode;
      this.tail = newNode;
    }
  }
  insertAfter(targetValue: string, value: string) {
    let newNode: ListNode = { val: value, next: null };
    let prev: ListNode | null = this.head;
    while (prev) {
      if (targetValue === prev.val) {
        newNode.next = prev.next;
        prev.next = newNode;
        if (newNode.next === null) this.tail = newNode;
        return;
      }
      prev = prev.next;
    }
  }
  insertAtIdx(value: string, idx: number) {
    let newNode: ListNode = { val: value, next: null };
    let prev: ListNode | null = this.head;
    let currentIdx = 0;

    if (idx === 0) {
      newNode.next = this.head;
      this.head = newNode;
      if (!this.tail) this.tail = newNode;
    }
    while (prev && currentIdx < idx - 1) {
      prev = prev.next;
      currentIdx++;
    }
    if (!prev) return;

    newNode.next = prev.next;
    prev.next = newNode;
  }
  deleteAtIdx(value: string, idx: number) {}
}
