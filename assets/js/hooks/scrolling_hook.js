let ScrollingHooks = {}

ScrollingHooks.scroll = {
  mounted() {
    document.addEventListener('DOMContentLoaded', () => {
      const toolInstallationElement =
        document.getElementById('tool-installation')
      if (toolInstallationElement) {
        toolInstallationElement.scrollLeft = toolInstallationElement.scrollWidth
      }
    })
  },
}

export default ScrollingHooks
