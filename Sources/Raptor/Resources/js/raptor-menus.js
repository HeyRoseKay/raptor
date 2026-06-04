/* -------------------------------------------------------------------------- */
/* MENUS                                                                      */
/* -------------------------------------------------------------------------- */

(() => {
    function positionDropdown(dropdown, trigger) {
        const menu = trigger.closest('.menu');
        const anchor = menu || trigger;
        const rect = anchor.getBoundingClientRect();
        const gap = 8;

        dropdown.style.top = '';
        dropdown.style.bottom = '';
        dropdown.style.left = '';
        dropdown.style.right = '';
        dropdown.style.margin = '0';

        const dw = dropdown.offsetWidth;
        const dh = dropdown.offsetHeight;
        const cl = menu?.classList;

        if (cl?.contains('dropdown-align-top')) {
            dropdown.style.bottom = (window.innerHeight - rect.top + gap) + 'px';
            dropdown.style.left = Math.round(rect.left + rect.width / 2 - dw / 2) + 'px';
        } else if (cl?.contains('dropdown-align-bottom')) {
            dropdown.style.top = (rect.bottom + gap) + 'px';
            dropdown.style.left = Math.round(rect.left + rect.width / 2 - dw / 2) + 'px';
        } else if (cl?.contains('dropdown-align-leading')) {
            dropdown.style.right = (window.innerWidth - rect.left + gap) + 'px';
            dropdown.style.top = Math.round(rect.top + rect.height / 2 - dh / 2) + 'px';
        } else if (cl?.contains('dropdown-align-trailing')) {
            dropdown.style.left = (rect.right + gap) + 'px';
            dropdown.style.top = Math.round(rect.top + rect.height / 2 - dh / 2) + 'px';
        } else if (cl?.contains('dropdown-align-topLeading')) {
            dropdown.style.bottom = (window.innerHeight - rect.top + gap) + 'px';
            dropdown.style.left = rect.left + 'px';
        } else if (cl?.contains('dropdown-align-topTrailing')) {
            dropdown.style.bottom = (window.innerHeight - rect.top + gap) + 'px';
            dropdown.style.right = (window.innerWidth - rect.right) + 'px';
        } else if (cl?.contains('dropdown-align-bottomTrailing')) {
            dropdown.style.top = (rect.bottom + gap) + 'px';
            dropdown.style.right = (window.innerWidth - rect.right) + 'px';
        } else if (cl?.contains('dropdown-align-center')) {
            dropdown.style.top = Math.round(rect.top + rect.height / 2 - dh / 2) + 'px';
            dropdown.style.left = Math.round(rect.left + rect.width / 2 - dw / 2) + 'px';
        } else {
            // Default: bottomLeading (matches former position:absolute top:100% left:0)
            dropdown.style.top = (rect.bottom + gap) + 'px';
            dropdown.style.left = rect.left + 'px';
        }
    }

    function adjustHeight(dropdown) {
        const rect = dropdown.getBoundingClientRect();
        const maxAvailable = window.innerHeight - Math.max(rect.top, 0) - 10;
        dropdown.style.maxHeight = `${maxAvailable}px`;
        dropdown.style.overflowY = 'auto';
    }

    // Dismiss mode: auto/manual
    function attachAutoDismiss(dropdown) {
        const root = dropdown.closest('[data-menu-dismiss], [data-dismiss]');
        const mode = root?.getAttribute('data-menu-dismiss') || root?.getAttribute('data-dismiss') || 'auto';
        if (mode !== 'auto') return;

        dropdown.querySelectorAll('a, button').forEach(el => {
            if (el.matches('[popovertarget]') || el.disabled || el.getAttribute('aria-disabled') === 'true') return;
            el.addEventListener('click', () => dropdown.hidePopover(), { once: true });
        });
    }

    function initMenus() {
        document.querySelectorAll('.menu-dropdown[popover]').forEach(dropdown => {
            const trigger = document.querySelector(`[popovertarget="${CSS.escape(dropdown.id)}"]`);
            if (!trigger) return;

            dropdown.addEventListener('toggle', e => {
                if (e.newState !== 'open') return;
                positionDropdown(dropdown, trigger);
                adjustHeight(dropdown);
                attachAutoDismiss(dropdown);
            });
        });

        window.addEventListener('resize', () => {
            document.querySelectorAll('.menu-dropdown[popover]').forEach(dropdown => {
                if (!dropdown.matches(':popover-open')) return;
                const trigger = document.querySelector(`[popovertarget="${CSS.escape(dropdown.id)}"]`);
                if (trigger) {
                    positionDropdown(dropdown, trigger);
                    adjustHeight(dropdown);
                }
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initMenus);
    } else {
        initMenus();
    }
})();

/* -------------------------------------------------------------------------- */
/* ACTIVE LINK HIGHLIGHT                                                       */
/* -------------------------------------------------------------------------- */

document.addEventListener('DOMContentLoaded', () => {
    const currentPath = window.location.pathname.replace(/\/$/, '');
    const currentHost = window.location.host;

    document.querySelectorAll('.menu-dropdown a').forEach(link => {
        const href = link.getAttribute('href');
        if (!href) return;

        try {
            const url = new URL(href, window.location.origin);

            if (url.host !== currentHost) return;

            const linkPath = url.pathname.replace(/\/$/, '');
            if (linkPath === currentPath) {
                link.dataset.active = 'true';
            }
        } catch {
            // Ignore invalid or malformed URLs
        }
    });
});
