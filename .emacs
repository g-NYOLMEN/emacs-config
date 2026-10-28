;; --- Wygląd i interfejs ---
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq warning-minimum-level :error)

;; --- Obsługa pakietów (MELPA) ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; --- Dopasowanie klawiszy i schowka ---
(windmove-default-keybindings 'meta)
(setq select-enable-clipboard t)
(cua-mode t)

;; --- Automatyczne uzupełnianie nawiasów i cudzysłowów ---
(electric-pair-mode 1)

;; --- Konfiguracja Custom (zarządzana przez Emacsa) ---
(custom-set-variables
 '(package-selected-packages '(vterm
                              doom-themes
                              treemacs
                              company
                              flycheck
                              modern-cpp-font-lock)))
(custom-set-faces)

;; --- Motyw ---
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; --- Treemacs (Drzewo plików) ---
(use-package treemacs
  :ensure t
  :config
  (setq treemacs-position 'left))

;; --- Terminal (vterm) ---
(use-package vterm
  :ensure t)

;; --- Inteligentne wsparcie dla C++ przez LSP (Eglot + clangd) ---
(use-package eglot
  :ensure t
  :hook ((c-mode . eglot-ensure)
         (c++-mode . eglot-ensure))
  :config
  (setq eglot-connect-timeout 10)
  (add-to-list 'eglot-ignored-server-capabilities :diagnosticProvider))
  (add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))
;; --- Wsparcie dla programowania C / C++ (Company) ---
(use-package company
  :ensure t
  :init
  (global-company-mode 1)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-auto-commit-chars nil)
  ;; Używamy backendu LSP (capf) zamiast zgadywania słów z tekstu
  (setq company-backends '((company-capf company-files)))

  (define-key company-active-map (kbd "TAB") 'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection))

;; Sprawdzanie błędów w czasie rzeczywistym
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode 1))

;; Lepsze podświetlanie składni nowoczesnego C++
(use-package modern-cpp-font-lock
  :ensure t
  :config
  (modern-c++-font-lock-global-mode t))

;; Standard C++ dla Flycheck
(setq flycheck-clang-language-standard "c++17")
(setq flycheck-gcc-language-standard "c++17")

;; --- WCIĘCIA: 4 spacje, koniec skakania ---
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq c-default-style "linux")

(defun my/c-mode-fix ()
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (c-toggle-electric-state -1)
  (c-toggle-auto-newline -1))

(add-hook 'c-mode-hook 'my/c-mode-fix)
(add-hook 'c++-mode-hook 'my/c-mode-fix)

;; --- Układ okien przy starcie ---
(defun my/startup-layout ()
  "Tworzy czysty układ: Treemacs po lewej, plik po prawej na górze, terminal na dole."
  (delete-other-windows)
  (treemacs)
  (windmove-right)
  (split-window-below -12)
  (other-window 1)
  (vterm)
  (other-window -1))
(add-hook 'emacs-startup-hook #'my/startup-layout)
