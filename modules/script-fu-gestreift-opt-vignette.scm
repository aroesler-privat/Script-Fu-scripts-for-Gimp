(script-fu-register-filter "script-fu-gestreift-opt-vignette"
	_"opt. Vignette"
	"Creates a vignette in a new layer. If there is no selection an ellipse covering the whole image will be selected."
	"Andreas"
	"andreas@gestreift.net"
	"April 2025"
	"*" 
	SF-ONE-DRAWABLE
	; ---[ add parameters ]-------------------------------------------------
	SF-OPTION   	_"Color"	'("Black" "Evil Red")
	SF-ADJUSTMENT 	_"Feather" 	'(0.15 0 1 0.01 0.10 3 0) ; <value> <min> <max> <step inc> <page inc> <digits> <0 for SLIDER> 
	; ----------------------------------------------------------------------
)

(script-fu-menu-register "script-fu-gestreift-opt-vignette" "<Image>/Filters/gestreift.net")

(define (script-fu-gestreift-opt-vignette
	image
	drawables
	color
	feather
	)
	(script-fu-use-v3)

	(if (or (not(vector? drawables)) (not(= (vector-length drawables) 1))) ((gimp-message-set-handler 0) (gimp-message "Please select precisely 1 drawable!") (quit 0)))

	(gimp-image-undo-group-start image)

	(gimp-progress-set-text "Vignette: Processing ...")

	; ---[ script body ]----------------------------------------------------

	(let* (
		(drawable       (vector-ref drawables 0))
		(drawableWidth  (gimp-drawable-get-width  drawable))
		(drawableHeight (gimp-drawable-get-height drawable))
		(vignetteLayer  (gimp-layer-new image "Vignette" drawableWidth drawableHeight RGBA-IMAGE 30 LAYER-MODE-SOFTLIGHT))
		(foreground     (gimp-context-get-foreground))
		(selection      (gimp-selection-bounds image))
		(x1             (cadr selection))
		(y1             (caddr selection))
		(x2             (car (cdr (cdr (cdr selection)))))
		(y2             (car (cdr (cdr (cdr (cdr selection))))))
		(featherX       (* feather (- x2 x1)))
		(featherY       (* feather (- y2 y1)))
		(featherI       (/ (+ featherX featherY) 2))
		)

		(gimp-image-insert-layer image vignetteLayer 0 0)

		(if (gimp-selection-is-empty image) (gimp-image-select-ellipse image CHANNEL-OP-REPLACE 0 0 drawableWidth drawableHeight))

		(cond
			((= color 0) (gimp-context-set-foreground "#000000"))
			((= color 1) (gimp-context-set-foreground "#450002"))
		)

		(gimp-selection-feather image featherI)
		(gimp-selection-invert image)
		(gimp-drawable-edit-fill vignetteLayer FILL-FOREGROUND)
		(gimp-context-set-foreground foreground)
		(gimp-selection-none image)
	)

	; ----------------------------------------------------------------------

	(gimp-progress-set-text "Vignette: Done.")
	(gimp-displays-flush)
	(gimp-image-undo-group-end image)
	(gimp-progress-end)

) ;end define
