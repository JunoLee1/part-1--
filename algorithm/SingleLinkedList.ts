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
      return;
    }
    while (prev && currentIdx < idx - 1) {
      prev = prev.next;
      currentIdx++;
    }
    if (!prev) return;

    newNode.next = prev.next;
    prev.next = newNode;
  }
  deleteAtIdx(idx: number) {
    if (this.head === null) return;
    let prev: ListNode | null = this.head;
    let prevIdx = 0;
    if (idx === 0) {
      this.head = this.head.next;
      return;
    }
    while (prev && prevIdx < idx - 1) {
      prev = prev.next;
      prevIdx++;
    }
    if (prev && prev.next) {
      prev.next = prev.next.next;
    }
  }
  delete(targetValue: string) {
    if (!this.head) return;
    let prev: ListNode | null = this.head;
    if (this.head.val === targetValue) {
      this.head = this.head.next;
      return;
    }
    while (prev.next) {
      if (prev.next.val === targetValue) {
        prev.next = prev.next.next;
        return;
      } else {
        prev = prev.next;
      }
    }
  }
}
