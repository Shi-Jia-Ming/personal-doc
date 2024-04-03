export default class DocLocation {
  private id: number;
  private key: string;
  private value: string;

  constructor(id: number, key: string, value: string) {
    this.id = id;
    this.key = key;
    this.value = value;
  }

  getId(): number {
    return this.id;
  }

  setId(id: number): void {
    this.id = id;
  }

  getKey(): string {
    return this.key;
  }

  setKey(key: string) {
    this.key = key;
  }

  getValue(): string {
    return this.value;
  }

  setValue(value: string): void {
    this.value = value;
  }
}
