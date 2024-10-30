(setq doom-theme 'doom-monokai-classic)
;; (setq doom-theme 'doom-homage-black)

;; Flexoki dark
(custom-set-faces '(default ((t (:background "#100F0F")))))

(setq doom-font(font-spec :family "Maple Mono NF" :size 14 :weight 'medium))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(undecorated . t))
;;(setq display-line-numbers-type 'relative)

(after! doom-modeline
  (setq doom-modeline-persp-name t)
  (setq doom-modeline-indent-info t)
  (setq doom-modeline-icon nil)
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-modal-icon nil
        evil-normal-state-tag   (propertize "NORMAL")
        evil-emacs-state-tag    (propertize "EMACS" )
        evil-insert-state-tag   (propertize "INSERT")
        evil-motion-state-tag   (propertize "MOTION")
        evil-visual-state-tag   (propertize "VISUAL")
        evil-operator-state-tag (propertize "OPERATOR")))

(setq fancy-splash-image "/home/gwn/my-emacs/images/conan-trasparent.jpg")
;; (remove-hook! '+doom-dashboard-functions #'doom-dashboard-widget-banner)

;; credit: yorickvP on Github
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe
                                      :noquery t))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
    (shell-command-to-string "wl-paste -n | tr -d \r")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

(setq evil-kill-on-visual-paste nil)


(setq org-directory "~/my-emacs/org/")
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode -1)))

(setq which-key-idle-delay 0.3)
(setq trash-directory "~/.local/share/Trash/files")
(setq delete-by-moving-to-trash t)

(defun open-dired-trash ()
  (interactive)
  (dired "~/.local/share/Trash/files"))

(map! :leader
      :desc "Open Trash"
      "o t" #'open-dired-trash)

(map!
 :leader
 :desc "Search yank" "y" #'consult-yank-from-kill-ring
 :desc "Kill this bufffer" "k" #'kill-this-buffer
 :desc "Toggle treemacs" "e" #'+treemacs/toggle
 ;; :desc "term" "o t" #'ansi-term
 :desc "vc ediff" "g ;" #'vc-ediff
 :desc "shell" "[" #'shell-command
 :desc "async shell" "]" #'async-shell-command
 :desc "shell projectile" "p [" #'projectile-run-shell-command-in-root
 :desc "async shell projectile" "p ]" #'projectile-run-async-shell-command-in-root
 ;; :desc "horizontal split" "8" #'evil-window-split
 ;; :desc "vertial split" "9" #'evil-window-vsplit
 ;; :desc "delete window" "0" #'evil-window-delete
 )

(defun my-evil-window-increase-height ()
  (interactive)
  (evil-window-increase-height 2))

(defun my-evil-window-decrease-height ()
  (interactive)
  (evil-window-decrease-height 2))

(map!
 ;; "C-l" #'+tabs:next-or-goto
 ;; "C-h" #'+tabs:previous-or-goto
 "C-l" #'next-buffer
 "C-h" #'previous-buffer
 "C-k" #'my-evil-window-increase-height
 "C-j" #'my-evil-window-decrease-height
 "C-1" #'centaur-tabs-move-current-tab-to-left
 "C-2" #'centaur-tabs-move-current-tab-to-right
 )

(map!
 "C-S-h" #'evil-window-left
 "C-S-l" #'evil-window-right
 "C-S-j" #'evil-window-down
 "C-S-k" #'evil-window-up)

(map!
 "C-8" #'evil-window-split
 "C-9" #'evil-window-vsplit
 "C-0" #'evil-window-delete)

(global-set-key (kbd "C-s") 'save-buffer)

(map! :n "C-/" #'comment-line)


(defun my-evil-mc-toggle-and-move-below ()
  (interactive)
  (+multiple-cursors/evil-mc-toggle-cursor-here)
  (evil-next-line))

(after! evil
  (dolist (binding '(("g ["   . flycheck-previous-error)
                     ("g ]"   . flycheck-next-error)
                     ("g /"   . list-flycheck-errors)
                     ("g \\"  . lsp-treemacs-errors-list)
                     ("g ."   . lsp-execute-code-action)
                     ("C-,"   . my-evil-mc-toggle-and-move-below)
                     ("C-<"   . +multiple-cursors/evil-mc-undo-cursor)
                     ("C-m"   . evil-mc-make-and-goto-next-match)
                     ("C-S-m" . evil-mc-make-all-cursors)
                     ("z ;"   . ansi-term)
                     ))
    (evil-define-key 'normal 'global (kbd (car binding)) (cdr binding))))

(add-to-list '+lookup-provider-url-alist '("Perplexity AI" "https://www.perplexity.ai/search/new?q=%s"))
(add-to-list '+lookup-provider-url-alist '("HexPM" "https://hex.pm/packages?search=%s&sort=recent_downloads"))
(add-to-list '+lookup-provider-url-alist '("HexDocs" "https://hexdocs.pm/%s"))
(add-to-list '+lookup-provider-url-alist '("HexDocs | Elixir"  "https://hexdocs.pm/elixir/search.html?q=%s"))
(add-to-list '+lookup-provider-url-alist '("HexDocs | Phoenix" "https://hexdocs.pm/phoenix/search.html?q=%s"))
(add-to-list '+lookup-provider-url-alist '("HexDocs | LiveView" "https://hexdocs.pm/phoenix_live_view/search.html?q=%s"))
(add-to-list '+lookup-provider-url-alist '("HexDocs | Ecto"  "https://hexdocs.pm/ecto/search.html?q=%s"))
(add-to-list '+lookup-provider-url-alist '("TailwindCSS"  "https://tailwindcss.com/docs/customizing-colors"))


(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("nextls" "--stdio"))
                    :multi-root t
                    :activation-fn (lsp-activate-on "elixir")
                    :server-id 'next-ls)))

(use-package lsp-mode
  :commands lsp
  :defer t
  :diminish lsp-mode
  :hook
  (elixir-ts-mode . lsp-deferred)
  (heex-ts-mode . lsp-deferred)
  (tsx-ts-mode . lsp-deferred)
  (typescript-ts-mode . lsp-deferred)
  (javascript-mode . lsp-deferred)
  (js-mode . lsp-deferred)
  :init
  (add-to-list 'exec-path "/home/gwn/language-server/elixir-ls")
  (setq lsp-use-plists t)
  (setq read-process-output-max (* 10 1024 1024))
  (setq gc-cons-threshold (* 50 1024 1024))

  :preface
  (defun lsp-booster--advice-json-parse (old-fn &rest args)
    "Try to parse bytecode instead of json."
    (or
     (when (equal (following-char) ?#)
       (let ((bytecode (read (current-buffer))))
         (when (byte-code-function-p bytecode)
           (funcall bytecode))))
     (apply old-fn args)))
  (advice-add (if (progn (require 'json)
                         (fboundp 'json-parse-buffer))
                  'json-parse-buffer
                'json-read)
              :around
              #'lsp-booster--advice-json-parse)

  (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
    "Prepend emacs-lsp-booster command to lsp CMD."
    (let ((orig-result (funcall old-fn cmd test?)))
      (if (and (not test?)                             ;; for check lsp-server-present?
               (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
               lsp-use-plists
               (not (functionp 'json-rpc-connection))  ;; native json-rpc
               (executable-find "emacs-lsp-booster"))
          (progn
            (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
              (setcar orig-result command-from-exec-path))
            (message "Using emacs-lsp-booster for %s!" orig-result)
            (cons "emacs-lsp-booster" orig-result))
        orig-result)))
  (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
  )

(setq lsp-dart-flutter-widget-guides nil)

(after! company
  (set-company-backend! 'org-mode nil)
  (set-company-backend! 't '(company-files company-capf))
  (setq company-idle-delay 0.1))

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(use-package elixir-ts-mode
  :defer t
  :mode (("\\.ex\\'" . elixir-ts-mode)
         ("\\.exs\\'" . elixir-ts-mode)
         ("\\.heex\\'" . heex-ts-mode))
  :config
  (define-derived-mode heex-ts-mode elixir-ts-mode "HEEx"
    "A major mode for HEEx template files.")
  )
(use-package typescript-ts-mode
  :defer t
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)))


(dolist (mapping
         '(
           ;; (typescript-mode . typescript-ts-mode)
           ;; (js-mode . typescript-ts-mode)
           ;; (js2-mode . typescript-ts-mode)
           (elixir-mode . elixir-ts-mode)
           ;; (json-mode . json-ts-mode)
           ;; (js-json-mode . json-ts-mode)
           ))
  (add-to-list 'major-mode-remap-alist mapping))


;; (after! evil
;;   (evil-define-key 'normal 'global (kbd "g [") #'flycheck-previous-error)
;;   )


;; (use-package! centaur-tabs
;;   :defer t
;;   :hook
;;   (org-mode . centaur-tabs-local-mode)
;;   (eshell-mode . centaur-tabs-local-mode)
;;   (term-mode . centaur-tabs-local-mode)
;;   (shell-mode . centaur-tabs-local-mode)
;;   (ibuffer-mode . centaur-tabs-local-mode)
;;   (anaconda-mode . centaur-tabs-local-mode)
;;   (wordnut-mode . centaur-tabs-local-mode)
;;   (eww-mode . centaur-tabs-local-mode)
;;   (dired-mode . centaur-tabs-local-mode))
;; (add-hook 'dired-mode-hook (lambda () (centaur-tabs-mode t)))  ; Enable local tabs in Dired buffers

;; (after! centaur-tabs
;;   (dolist (prefix '("*Shell Command Output"
;;                     "*scratch"
;;                     "*eldoc"
;;                     "*doom"
;;                     "*vc-diff"
;;                     "*Native-compile-Log"
;;                     "*Async-native"
;;                     "*Messages"
;;                     "*EGLOT"
;;                     "*elixir-ls"
;;                     "*tailwind"
;;                     "*Async Shell"
;;                     "*compilation"
;;                     "*Org"))
;;     (add-to-list 'centaur-tabs-excluded-prefixes prefix)))


;; (use-package treesit
;;   :defer t
;;   :mode (("\\.tsx\\'" . tsx-ts-mode)
;;          ("\\.js\\'"  . typescript-ts-mode)
;;          ("\\.mjs\\'"  . typescript-ts-mode)
;;          ("\\.ts\\'"  . typescript-ts-mode)
;;          ("\\.jsx\\'" . tsx-ts-mode)
;;          ("\\.json\\'" .  json-ts-mode)
;;          ("\\.Dockerfile\\'" . dockerfile-ts-mode)
;;          ("\\.prisma\\'" . prisma-ts-mode)
;;          ("\\.heex\\'" . heex-ts-mode)
;;          ("\\.ex\\'" . elixir-ts-mode)
;;          ("\\.exs\\'" . elixir-ts-mode)
;;          )
;;   :preface
;;   (defun mp-setup-install-grammars ()
;;     "Install Tree-sitter grammars if they are absent."
;;     (interactive)
;;     (dolist (grammar
;;              '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
;;                (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
;;                (bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
;;                (elisp . ("https://github.com/Wilfred/tree-sitter-elisp"))
;;                (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.1" "src"))
;;                (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
;;                (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
;;                (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;                (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
;;                (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
;;                (elixir . ("https://github.com/elixir-lang/tree-sitter-elixir"))
;;                (heex . ("https://github.com/phoenixframework/tree-sitter-heex"))
;;                (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
;;                (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
;;                (dart . ("https://github.com/UserNobody14/tree-sitter-dart"))
;;                (markdown . ("https://github.com/ikatyang/tree-sitter-markdown"))
;;                (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))))
;;       (add-to-list 'treesit-language-source-alist grammar)
;;       ;; Only install `grammar' if we don't already have it
;;       ;; installed. However, if you want to *update* a grammar then
;;       ;; this obviously prevents that from happening.
;;       (unless (treesit-language-available-p (car grammar))
;;         (treesit-install-language-grammar (car grammar)))))

;;   (dolist (mapping
;;            '((python-mode . python-ts-mode)
;;              (css-mode . css-ts-mode)
;;              (typescript-mode . typescript-ts-mode)
;;              (js-mode . typescript-ts-mode)
;;              (js2-mode . typescript-ts-mode)
;;              (bash-mode . bash-ts-mode)
;;              (elixir-mode . elixir-ts-mode)
;;              (heex-mode . heex-ts-mode)
;;              (c-mode . c-ts-mode)
;;              (c++-mode . c++-ts-mode)
;;              (c-or-c++-mode . c-or-c++-ts-mode)
;;              (sh-mode . bash-ts-mode)
;;              (json-mode . json-ts-mode)
;;              (js-json-mode . json-ts-mode)))
;;     (add-to-list 'major-mode-remap-alist mapping))
;;   ;; :config
;;   ;; (mp-setup-install-grammars)
;;   )


;; (use-package apheleia
;;   :defer t
;;   :config
;;   (apheleia-global-mode +1)
;;   (with-eval-after-load 'apheleia
;;     (setf (alist-get 'heex apheleia-formatters)
;;           '("mix" "format" buffer-file-name)))
;;   (add-to-list 'apheleia-mode-alist '(heex-ts-mode . heex)))

;; (after! lsp-tailwindcss
;;   (setq lsp-tailwindcss-add-on-mode t)
;;   (dolist (tw-major-mode
;;            '(css-mode
;;              css-ts-mode
;;              typescript-mode
;;              typescript-ts-mode
;;              tsx-ts-mode
;;              js2-mode
;;              js-ts-mode
;;              clojure-mode))
;;     (add-to-list 'lsp-tailwindcss-major-modes tw-major-mode))
;;   (add-to-list 'lsp-language-id-configuration '(".*\\.heex$" . "html")))
