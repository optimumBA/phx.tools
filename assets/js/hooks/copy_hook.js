export default {
  mounted() {
    this.el.addEventListener('click', () => {
      var copyText = document.getElementById('tool-installation').innerText
      navigator.clipboard.writeText(copyText)
      copyBtn = document.getElementById('copy')
      copyBtn.innerHTML = 'Copied'
      copyBtn.setAttribute('disabled', '')
      copyBtn.classList.add('bg-[#9887FF]')

      setTimeout(() => {
        copyBtn.innerHTML = '<img src="/images/clipboard.svg" />'
        copyBtn.removeAttribute('disabled')
        copyBtn.classList.remove('bg-[#9887FF]')
      }, 3000)
    })
  },
}
