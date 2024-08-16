export default {
  mounted() {
    this.el.addEventListener('click', () => {
      var copyText = document.getElementById('tool-installation').innerText
      navigator.clipboard.writeText(copyText)
      copyBtn = document.getElementById('copy')
      copyBtn.innerHTML = '<img src="/images/check.svg" />'
      copyBtn.setAttribute('disabled', '')

      setTimeout(() => {
        copyBtn.innerHTML = '<img src="/images/clipboard.svg" />'
        copyBtn.removeAttribute('disabled')
        copyBtn.classList.remove('bg-[#9887FF]')
      }, 3000)
    })
  },
}
