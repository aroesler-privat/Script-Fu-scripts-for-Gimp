(script-fu-register-filter "script-fu-gestreift-opt-skinglow"
	_"opt. Skin Glow"
	"Creates two new layers using shadow highlights: Skin Glow Low and Relight II."
	"Andreas"
	"andreas@gestreift.net"
	"January 2026"
	"*" 
	SF-ONE-DRAWABLE
)

(script-fu-menu-register "script-fu-gestreift-opt-skinglow" "<Image>/Filters/gestreift.net")

(define (script-fu-gestreift-opt-skinglow
	image
	drawables
	)
	(script-fu-use-v3)

	(if (or (not(vector? drawables)) (not(= (vector-length drawables) 1))) ((gimp-message-set-handler 0) (gimp-message "Please select precisely 1 drawable!") (quit 0)))

	(gimp-image-undo-group-start image)

	(gimp-progress-set-text "Skin Glow: Processing ...")

	; ---[ script body ]----------------------------------------------------

	(let* 	(
			(drawable      (vector-ref drawables 0))
			(drawableName  (gimp-item-get-name drawable))
			(parent        (gimp-item-get-parent drawable))
			(position      (gimp-image-get-item-position image drawable))

			(glow-group (gimp-group-layer-new image "(Skin) Glow"))
			(glow-layer (gimp-layer-new-from-visible image image "Skin Glow (Shadow & Lights)"))
		)

	  	(gimp-image-insert-layer image glow-group 0 0)
	  	(gimp-image-insert-layer image glow-layer glow-group -1)

		(gimp-drawable-shadows-highlights glow-layer
				-60 ; Schatten
				-45 ; Glanzlicher
				2.0 ; Weißpunkt
				50  ; Radius
				65  ; Komprimieren
				100 ; Farbkorrektur Schatten
				50  ; Farbkorrektur Glanzlichter
		)

		(gimp-layer-set-opacity glow-layer 80)

		(let* 	(
				(relight-layer (gimp-layer-copy glow-layer FALSE))
			)

			(gimp-image-insert-layer image relight-layer glow-group -1)
			(gimp-item-set-name relight-layer "Relight II (Shadow & Lights)")

			(gimp-drawable-shadows-highlights relight-layer
				55  ; Schatten
				20  ; Glanzlicher
				7.5 ; Weißpunkt
				110 ; Radius
				35  ; Komprimieren
				45  ; Farbkorrektur Schatten
				100 ; Farbkorrektur Glanzlichter
			)

			(gimp-layer-set-opacity relight-layer 50)
		)

		(gimp-item-set-visible glow-layer FALSE)
	)

	; ----------------------------------------------------------------------

	(gimp-progress-set-text "Skin Glow: Done.")
	(gimp-displays-flush)
	(gimp-image-undo-group-end image)
	(gimp-progress-end)

) ;end define
