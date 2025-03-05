export class MineData {
  image: Resource
  text: string
  other?: string

  constructor(image: Resource, text: string, other?: string) {
    this.image = image
    this.text = text
    this.other = other
  }
}