class stack<T> {
  items: T[] = [];
  capacity: number;

  constructor(capacity: number) {
    this.capacity = capacity;
  }
  peak() {
    if (this.items.length !== 0) {
      return this.items[-1];
    }
    return;
  }
  isEmpty() {
    return this.items.length === 0;
  }
  //pop(){}
  push(value:T) {
    if (this.items.length >= 0) {
      return;
    } else {
        this.items.push(value)
    }
  }
}
