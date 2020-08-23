(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "Emacs ready in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))
(let ((file-name-handler-alist nil))
;;(setq debug-on-error t)
(setq gc-cons-threshold most-positive-fixnum)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
;; https://github.crookster.org/switching-to-straight.el-from-emacs-26-builtin-package.el/
;; (customize-set-variable 'package-archives
;;                         '(("melpa"     . "https://melpa.org/packages/")
;; 			  ("elpa"      . "https://elpa.gnu.org/packages/")
;; 			  ("org"       . "https://orgmode.org/elpa/")))
;; (package-initialize)

;; (when (not package-archive-contents)
;;   (package-refresh-contents))

;; (when (not (package-installed-p 'use-package))
;;   (package-install 'use-package))
;; (require 'use-package)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;;;;  Effectively replace use-package with straight-use-package
;;; https://github.com/raxod502/straight.el/blob/develop/README.md#integration-with-use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;;;  package.el
;;; so package-list-packages includes them
(require 'package)
(add-to-list 'package-archives
           '("melpa" . "https://melpa.org/packages/"))


;; (customize-set-variable 'use-package-always-ensure t)
;; (customize-set-variable 'use-package-always-defer t)
;; (customize-set-variable 'use-package-verbose nil)
;; (customize-set-variable 'load-prefer-newer t)
(customize-set-variable 'load-prefer-newer t)
(use-package auto-compile
  :defer nil
  :config (auto-compile-on-load-mode))
(add-to-list 'load-path "~/.emacs.d/lisp")
(setq frame-title-format '("%b"))
(use-package guru-mode
  :demand
  :config
  (guru-global-mode +1))
(use-package emacs
  :init
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (show-paren-mode 1)
  (global-visual-line-mode)
  :config
  (setq inhibit-splash-screen t)
  (require 'cl)
  (set 'mouse-autoselect-window nil)
  (set 'focus-follows-mouse nil)
  (set 'frame-auto-hide-function 'delete-frame))
(setq-default whitespace-line-column 80
 whitespace-style       '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode)
(use-package ace-window
  :bind (( "M-o" . ace-window)))
(use-package emacs
  :config
  (setq backup-directory-alist
        '(("." . "~/.emacs.d/backup/")))
  (setq backup-by-copying t)
  (setq version-control t)
  (setq delete-old-versions t)
  (setq kept-new-versions 6)
  (setq kept-old-versions 2)
  (setq create-lockfiles nil))
(use-package all-the-icons
  ;;:defer 3
  )
(use-package all-the-icons-dired
  :defer 3)
(use-package dired
  ;;:ensure nil
  :straight (dired :type built-in)
  :bind (( "C-x C-j" . dired-jump))
  :hook
  (dired-mode . all-the-icons-dired-mode))
(use-package doom-themes
  :defer nil
  :config
  (setq doom-themes-enable-bold t            ; if nil, bold is universally disabled
	doom-themes-enable-italic t          ; if nil, italics is universally disabled
        doom-nord-light-brighter-comments t) ; brighter comments
  (load-theme 'doom-nord-light t)
  (doom-themes-org-config))
(use-package doom-modeline
  :init
  (doom-modeline-mode 1))
(use-package activity-watch-mode
  :config
  (global-activity-watch-mode))
(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (defun my-nov-font-setup ()
  (face-remap-add-relative 'variable-pitch :family "Liberation Serif"
                           :height 1.5))
  (add-hook 'nov-mode-hook 'my-nov-font-setup))
(use-package s) 
(use-package htmlize)
(use-package csv-mode)
(use-package org-cliplink)
(use-package go-mode)
(use-package magit)
(use-package puppet-mode)
(use-package lua-mode)
(use-package beacon
  :demand
  :config
  (beacon-mode t))
(use-package mu4e
  :load-path "/usr/local/share/emacs/site-lisp//mu4e"
  ;;:ensure nil
  :straight (mu4e :type built-in)
  :commands mu4e
  :config
  (setq
   mu4e-maildir       "~/Mail/BadooWrk"   ;; top-level Maildir
   mu4e-sent-folder   "/sent"             ;; folder for sent messages
   mu4e-drafts-folder "/drafts"           ;; unfinished messages
   mu4e-trash-folder  "/Trash"            ;; trashed messages
   mu4e-refile-folder "/Archived")        ;; saved messages

  (setq mu4e-sent-messages-behavior 'delete)
  (setq message-kill-buffer-on-exit t)

  (setq mu4e-reply-to-address "r.grazhdan@corp.badoo.com"
	user-mail-address "r.grazhdan@corp.badoo.com"
	user-full-name  "Roman Grazhdan")
  (setq mu4e-compose-signature
	"¯\(°_o)/¯. ¯\_(ツ)_/¯\n")
  (setq send-mail-function 'sendmail-send-it
      sendmail-program "/usr/bin/msmtp"
      mail-specify-envelope-from t
      message-sendmail-envelope-from 'header
      mail-envelope-from 'header)

  (setq mu4e-attachment-dir  "~/Ledger/checks/incoming/")

  (setq mu4e-bookmarks
	`(, (make-mu4e-bookmark
	     :name "todos"
	     :query "subject:todo*"
	     :key ?t)
	    ,(make-mu4e-bookmark
	      :name "photosdirector"
	      :query "to:photosdirector@corp.badoo.com"
	      :key ?p)
	    ,(make-mu4e-bookmark
	      :name "robots"
	      :query "from:zabbix* or from:dnsupdate* or from:alter@corp.badoo.com or from:root@systmain1.mlan"
	      :key ?r)
	    ,(make-mu4e-bookmark
	      :name "git"
	      :query "subject:[GIT]* or subject:daemon_configs.git* AND NOT flag:trashed"
	      :key ?g)
	    ,(make-mu4e-bookmark
	      :name "maintenance"
	      :query "to:maintenance"
	      :key ?m)
	    ,(make-mu4e-bookmark
	      :name "JIRA"
	      :query "subject:[JIRA]* or from:*(Jira) and flag:unread"
	      :key ?j)
	    ,(make-mu4e-bookmark
	      :name "confluence"
	      :query "subject:[confluence]* and flag:unread"
	      :key ?c)
	    ,(make-mu4e-bookmark
	      :name  "Unread messages"
	      :query "flag:unread AND NOT flag:trashed"
	      :key ?u)
	    ,(make-mu4e-bookmark
	      :name "statushero"
	      :query "from:app@statushero.com"
	      :key ?s)
	    ,(make-mu4e-bookmark
	      :name  "Ledger"
	      :query "subject:Копия чека or subject:ledger"
	      :key ?l)))

  (add-to-list 'mu4e-view-actions
	       '("ViewInBrowser" . mu4e-action-view-in-browser) t))
(use-package elfeed)

(use-package elfeed-org
  :config
  (setq rmh-elfeed-org-files (list "/home/hoodoo/Org/RSS.org")))
(use-package pomidor
  :bind (("<f12>" . pomidor))
  :config (setq pomidor-sound-tick nil
                pomidor-sound-tack nil)
  :hook (pomidor-mode . (lambda ()
                          (display-line-numbers-mode -1) ; Emacs 26.1+
                          (setq left-fringe-width 0 right-fringe-width 0)
                          (setq left-margin-width 2 right-margin-width 0)
                          ;; force fringe update
                          (set-window-buffer nil (current-buffer)))))
(use-package helm
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    (setq helm-swoop-pre-input-function (lambda () ""))
                                      ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-idle-delay 0.0         ; update fast sources immediately (doesn't).
          helm-input-idle-delay 0.01  ; this actually updates things
                                      ; reeeelatively quickly.
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t
          helm-buffer-max-length nil)
    (helm-mode))
  :bind (("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-h a" . helm-apropos)
;;         ("C-x C-b" . helm-buffers-list)
;;         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-s" . helm-swoop)
         ("C-x c y" . helm-yas-complete)
         ("C-x c Y" . helm-yas-create-snippet-on-region)
         ;; ("C-x c b" . my/helm-do-grep-book-notes)
         ("C-x c SPC" . helm-all-mark-rings)))
(use-package helm-swoop)
(use-package helm-projectile)
(use-package helm-ag)
  ;;https://github.crookster.org/switching-to-straight.el-from-emacs-26-builtin-package.el/

;;______________________________________________________________________
;;;;  Installing Org with straight.el
;;; https://github.com/raxod502/straight.el/blob/develop/README.md#installing-org-with-straightel
(require 'subr-x)
(straight-use-package 'git)

(defun org-git-version ()
  "The Git version of 'org-mode'.
Inserted by installing 'org-mode' or when a release is made."
  (require 'git)
  (let ((git-repo (expand-file-name
		   "straight/repos/org/" user-emacs-directory)))
    (string-trim
     (git-run "describe"
	      "--match=release\*"
	      "--abbrev=6"
	      "HEAD"))))

(defun org-release ()
  "The release version of 'org-mode'.
  Inserted by installing 'org-mode' or when a release is made."
  (require 'git)
  (let ((git-repo (expand-file-name
		   "straight/repos/org/" user-emacs-directory)))
    (string-trim
     (string-remove-prefix
      "release_"
      (git-run "describe"
	       "--match=release\*"
	       "--abbrev=0"
	       "HEAD")))))

(provide 'org-version)

;; (straight-use-package 'org) ; or org-plus-contrib if desired
(use-package ox-jira
  :config
  (require 'ox-jira))
(use-package org-plus-contrib
    ;;:pin "org"				
    ;;:ensure org-plus-contrib
    :no-require t
    :bind (( "C-c C-a" . org-agenda )
	   ( "C-c c" . org-capture)
	   ( "C-c C-o" . org-open-at-point))
    :preface
    (setq org-modules '(org-habit))
    :config
    (require 'org-id)
    ;; https://github.com/syl20bnr/spacemacs/issues/11798
    ;; <s broken in recent org-mode
    (require 'org-tempo)
    (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
    (setq  org-src-fontify-natively t)
    (setq org-hide-emphasis-markers t)
    (setq org-todo-keyword-faces
	  '(("TODO" . "dark salmon")
	    ("WAIT" . "sandybrown")
	    ("NEXT" . "pale violet red")
	    ("DONE" . "darkgreen")
	    ("CANCEL" . "yellowgreen")
	    ("PROC" . "darkgreen")))
    (setq org-tags-column (- 4 (window-width)))

    (defun my-babel-to-buffer ()
      "A function to efficiently feed babel code block result to a separate buffer"
      (interactive)
      (org-open-at-point)
      (org-babel-remove-result))
    (defun my-org-mode-config ()
      "To use with `org-mode-hook'"
      (local-set-key (kbd "C-`") 'my-babel-to-buffer))

    (add-hook 'org-mode-hook 'my-org-mode-config)

    (org-babel-do-load-languages
     'org-babel-load-languages
     '((shell . t)
       (ruby . t)
       (emacs-lisp . t)
       (haskell . t)
       (python . t)
       (dot .t)
       (lua . t)
       ))

    (setq org-log-done t)
    (setq org-clock-persist 'history)
    (org-clock-persistence-insinuate)

    (define-key org-mode-map (kbd "M-p") 'org-move-subtree-up)
    (define-key org-mode-map (kbd "M-n") 'org-move-subtree-down))
(use-package org-super-agenda)
(use-package org-agenda
  ;;:ensure nil
  :straight (org-agenda :type built-in)
  :after (org)
  :config
  (setq org-agenda-files '("~/Org/AREAS" "~/Org/PROJECTS")) 
  (setq org-agenda-prefix-format "%t %s")
  (setq org-agenda-tags-column (- 2 (window-width)))
  (setq org-agenda-custom-commands
	`(("c" "Super Agenda" 
	   ((agenda)
	    (alltodo (org-super-agenda-mode)
		     ((org-agenda-overriding-header "")
		      (org-super-agenda-groups
		       '(
			 ;; Since the tasks scheduled for this week are showed in agenda I don't
			 ;; need them in the list
			 (:discard (:scheduled (before ,(org-read-date nil nil "Sun"))))
			 (:name "Unscheduled work tasks"
				:tag "work")))))))))

					; This is ugly. With org-roam, I use links in headlines _A LOT_, and links in headlines
					; currently break agenda, so what do I do...

					; Although I don't use org-roam anymore, I stlill leave this function here

					; I've removed a call to add-text-porperties, it now seems to work okay
  (defun org-agenda-finalize ()
    "Finishing touch for the agenda buffer, called just before displaying it."
    (unless org-agenda-multi
      (save-excursion
	(let ((inhibit-read-only t))
	  (goto-char (point-min))
	  (save-excursion
	    (while (org-activate-links (point-max))))
	  (unless (eq org-agenda-remove-tags t)
	    (org-agenda-align-tags))
	  (unless org-agenda-with-colors
	    (remove-text-properties (point-min) (point-max) '(face nil)))
	  (when (bound-and-true-p org-overriding-columns-format)
	    (setq-local org-local-columns-format
			org-overriding-columns-format))
	  (when org-agenda-view-columns-initially
	    (org-agenda-columns))
	  (when org-agenda-fontify-priorities
	    (org-agenda-fontify-priorities))
	  (when (and org-agenda-dim-blocked-tasks org-blocker-hook)
	    (org-agenda-dim-blocked-tasks))
	  (org-agenda-mark-clocking-task)
	  (when org-agenda-entry-text-mode
	    (org-agenda-entry-text-hide)
	    (org-agenda-entry-text-show))
	  (when (and (featurep 'org-habit)
		     (save-excursion (next-single-property-change (point-min) 'org-habit-p)))
	    (org-habit-insert-consistency-graphs))
	  (setq org-agenda-type (org-get-at-bol 'org-agenda-type))
	  (unless (or (eq org-agenda-show-inherited-tags 'always)
		      (and (listp org-agenda-show-inherited-tags)
			   (memq org-agenda-type org-agenda-show-inherited-tags))
		      (and (eq org-agenda-show-inherited-tags t)
			   (or (eq org-agenda-use-tag-inheritance t)
			       (and (listp org-agenda-use-tag-inheritance)
				    (not (memq org-agenda-type
					       org-agenda-use-tag-inheritance))))))
	    (let (mrk)
	      (save-excursion
		(goto-char (point-min))
		(while (equal (forward-line) 0)
		  (when (setq mrk (get-text-property (point) 'org-hd-marker))
		    (put-text-property (point-at-bol) (point-at-eol)
				       'tags
				       (org-with-point-at mrk
					 (mapcar #'downcase (org-get-tags)))))))))
	  (setq org-agenda-represented-tags nil
		org-agenda-represented-categories nil)
	  (when org-agenda-top-headline-filter
	    (org-agenda-filter-top-headline-apply
	     org-agenda-top-headline-filter))
	  (when org-agenda-tag-filter
	    (org-agenda-filter-apply org-agenda-tag-filter 'tag t))
	  (when (get 'org-agenda-tag-filter :preset-filter)
	    (org-agenda-filter-apply
	     (get 'org-agenda-tag-filter :preset-filter) 'tag t))
	  (when org-agenda-category-filter
	    (org-agenda-filter-apply org-agenda-category-filter 'category))
	  (when (get 'org-agenda-category-filter :preset-filter)
	    (org-agenda-filter-apply
	     (get 'org-agenda-category-filter :preset-filter) 'category))
	  (when org-agenda-regexp-filter
	    (org-agenda-filter-apply org-agenda-regexp-filter 'regexp))
	  (when (get 'org-agenda-regexp-filter :preset-filter)
	    (org-agenda-filter-apply
	     (get 'org-agenda-regexp-filter :preset-filter) 'regexp))
	  (when org-agenda-effort-filter
	    (org-agenda-filter-apply org-agenda-effort-filter 'effort))
	  (when (get 'org-agenda-effort-filter :preset-filter)
	    (org-agenda-filter-apply
	     (get 'org-agenda-effort-filter :preset-filter) 'effort))
	  (add-hook 'kill-buffer-hook 'org-agenda-reset-markers 'append 'local)
	  (run-hooks 'org-agenda-finalize-hook))))))
(use-package org-fragtog
  :hook
  (org-mode . org-fragtog-mode))
  (use-package helm-org
    :demand)

  (use-package org-ql
    :demand
    :after (helm-org)			
    :straight (org-ql
              :type git 
	      :host github 
	      :repo "alphapapa/org-ql")
    :config
    (require 'helm-org-ql))

    (use-package helm-org-rifle
    :demand)

(use-package org-super-links
  :after (helm-org-rifle)
  :straight (org-super-links
             :type git
	     :host github
	     :repo "toshism/org-super-links")
  :bind (("C-c s s" . sl-link)
	   ("C-c s l" . sl-store-link)
	   ("C-c s C-l" . sl-insert-link))
  :config
  (setq sl-search-function 'helm-org-rifle))

(use-package pdf-tools
  :config
  (pdf-tools-install)
  (setq pdf-annot-activate-created-annotations t)
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete))
;;NOTE that the highlighting works even in comments.
(use-package hl-todo
  :config
  ;; Adding a new keyword: TEST.
  (add-to-list 'hl-todo-keyword-faces '("TEST" . "#dc8cc3"))
  :init
  (add-hook 'text-mode-hook (lambda () (hl-todo-mode t)))
)
(use-package magit-todos
  :after magit
  :after hl-todo
  :config
  (magit-todos-mode))
(use-package undo-tree
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))
(defun insdate-insert-current-date (&optional omit-day-of-week-p)
  "Insert today's date using the current locale.
  With a prefix argument, the date is inserted without the day of
  the week."
  (interactive "P*")
  (insert (calendar-date-string (calendar-current-date) nil
				omit-day-of-week-p)))

(global-set-key "\C-x\M-d" `insdate-insert-current-date)
)
(setq gc-cons-threshold (* 2 1000 1000))
(put 'narrow-to-region 'disabled nil)
