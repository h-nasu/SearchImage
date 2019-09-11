
class SIUtils {
  constructor() {
    this.name = 'Polygon'
  }
  test() {
    return this.name
  }
  getAllImages() {
    let images = []
    document.querySelectorAll('img').forEach((img) => {
      if (img.src.includes('http://') || img.src.includes('https://')) {
        images.push(img.src)
      }
    })
    return images
  }
}
