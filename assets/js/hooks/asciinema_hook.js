export default {
  mounted() {
    const id = this.el.dataset.asciicast
    const script = document.createElement('script')
    script.id = `asciicast-${id}`
    script.src = `https://asciinema.org/a/${id}.js`
    this.el.appendChild(script)
  },
}
