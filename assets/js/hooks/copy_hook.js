export default {
  mounted() {
    this.el.addEventListener('click', () => {
      var copyText = document.getElementById('tool-installation').innerText
      navigator.clipboard.writeText(copyText)
      copyBtn = document.getElementById('copy')
      copyBtn.innerHTML = 'Copied'
      copyBtn.setAttribute('disabled', '')
      copyBtn.classList.add('bg-[#9887FF]')
    })
  },
}
