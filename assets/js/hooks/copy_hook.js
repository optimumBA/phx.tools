export default {
  mounted() {
    const copyContainer = this.el
    const copyElement = document.getElementById('copy-icon')
    const copyConfirmationElement = document.getElementById('copied-icon')

    copyContainer.addEventListener('click', (event) => {
      event.preventDefault()
      event.stopPropagation()

      const copyText = document.getElementById('tool-installation').innerText
      navigator.clipboard.writeText(copyText)
      copyElement.classList.add('hidden')
      copyConfirmationElement.classList.remove('hidden')

      setTimeout(() => {
        copyConfirmationElement.classList.add('hidden')
        copyElement.classList.remove('hidden')
      }, 600)
    })
  },
}
