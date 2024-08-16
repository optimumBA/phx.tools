export default {
  mounted() {
    const { live_action } = this.el.dataset
    const id =
      live_action === 'linux'
        ? 'XhDpRstBJ4df2gfiRfp0awDPO'
        : live_action === 'macOS'
          ? 'bJMOlPe5F4mFLY0Rl6fiJSOp3'
          : null

    if (id) {
      const script = document.createElement('script')
      script.id = `asciicast-${id}`
      script.src = `https://asciinema.org/a/${id}.js`
      this.el.appendChild(script)
    }
  },
}
