# Adds a floating back to top button to the bottom right corner of the page
# that appears once the page has been scrolled by one turn of the wheel.
Asciidoctor::Extensions.register do
  docinfo_processor do
    at_location :head
    process do |doc|
      <<~'EOS'.chomp
      <style>
      #back-to-top {
        background-color: #2156a5;
        border: 0;
        border-radius: 50%;
        bottom: 0.75em;
        color: #ffffff;
        font-size: 1em;
        font-weight: bold;
        height: 2.5em;
        opacity: 0;
        position: fixed;
        right: 1.25em;
        visibility: hidden;
        width: 2.5em;
      }
      #back-to-top.show, #back-to-top * {
        cursor: pointer !important;
      }
      #back-to-top.show {
        opacity: 1;
        transition: opacity 0.25s ease-in;
        visibility: visible;
      }
      </style>
      EOS
    end
  end

  docinfo_processor do
    at_location :footer
    process do |doc|
      <<~EOS.chomp
      <button class="btn" id="back-to-top">
      <span class="icon">#{(doc.attr? 'icons', 'font') ? '<i class="fa fa-arrow-up"></i>' : '^'}</span>
      </button>
      <script>
      (function () {
        function initializeBackToTopButton (button) {
          button.addEventListener('click', jumpToTop)
          toggleBackToTopButton.call(button)
          window.addEventListener('scroll', toggleBackToTopButton.bind(button))
        }

        function toggleBackToTopButton () {
          window.scrollY > 40 ? this.classList.add('show') : this.classList.remove('show')
        }

        function jumpToTop () {
          window.scrollTo({ top: 0, behavior: 'auto' })
        }

        initializeBackToTopButton(document.getElementById('back-to-top'))
      })()
      </script>
      EOS
    end
  end
end
