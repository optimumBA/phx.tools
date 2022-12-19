export default {
  mounted() {
    this.el.addEventListener('click', () => {
      var copyText = document.getElementById('tool-installation').innerHTML
      navigator.clipboard.writeText(copyText)
      document.getElementById('copy').innerHTML = 'Copied'
      document.getElementById('copy').setAttribute('disabled', '')
      document.getElementById('copy').classList.add('bg-[#9887FF]')
    })
  },
}
