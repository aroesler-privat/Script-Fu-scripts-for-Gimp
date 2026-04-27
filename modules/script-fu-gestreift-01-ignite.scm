; Ebene duplizieren -> " (Contrast)" anhängen, Deckkraft 33%
;                   -> Modus "Weiche Kanten"
;                   -> wenn gewählt, dann Farben -> Entsättigen -> Entsättigen -> Leuchtkraft
;                   -> ausblenden
; Ebene duplizieren -> " (Contrast Mask)" anhängen, Deckkraft 80%
;                   -> Farben -> Invertieren
;                   -> ausblenden
; Ebene duplizieren -> " (Ignite)" anhängen, Deckkraft 66%
;                   -> G'MIC -> Blur [Depth-Of-Field]

(script-fu-register-filter "script-fu-gestreift-01-ignite"
	_"01 Ignite into a fire"
	"Creates three layers: Ignite (containing the actual effect), Contrast Mask, and Contrast. The last two layers are hidden, but they are often useful in certain settings when using layer masks for image details."
	"Andreas"
	"andreas@gestreift.net"
	"April 2026"
	"*" 
	SF-ONE-DRAWABLE
	SF-TOGGLE     _"Desaturate layers?" TRUE
)

(script-fu-menu-register "script-fu-gestreift-01-ignite" "<Image>/Filters/gestreift.net")

(define (script-fu-gestreift-01-ignite
	image
	drawables
	do-desaturate
	)
	(script-fu-use-v3)

	(if (or (not(vector? drawables)) (not(= (vector-length drawables) 1))) 
		(begin (gimp-message "Please select precisely 1 layer!") (quit 0))
	)

	(gimp-image-undo-group-start image)
    
	(gimp-progress-set-text "Ignite into a fire: Processing ...")

	(let* 	(
			(drawable      (vector-ref drawables 0))
			(drawableName  (gimp-item-get-name drawable))
			(parent        (gimp-item-get-parent drawable))
			(position      (gimp-image-get-item-position image drawable))

			(ignite-group (gimp-group-layer-new image "Ignite into a fire"))
		
			(contrast-layer (gimp-layer-new-from-visible image image "Raise Contrast"))
		)

	  	(gimp-image-insert-layer image ignite-group parent 0)
		(gimp-layer-set-mode ignite-group LAYER-MODE-SOFTLIGHT)

		(gimp-image-insert-layer image contrast-layer ignite-group -1)
		(gimp-layer-set-opacity contrast-layer 33.0)
        
		(if (= do-desaturate TRUE)
			(gimp-drawable-desaturate contrast-layer DESATURATE-LUMA)
		)

		(let* 	(
				(invert-layer (gimp-layer-copy contrast-layer FALSE))
			)
            
			(gimp-image-insert-layer image invert-layer ignite-group -1)
			(gimp-item-set-name invert-layer "Contrast Mask")
			(gimp-layer-set-opacity invert-layer 80.0)
           
			(gimp-drawable-invert invert-layer FALSE)

			(let* 	(
					(blur-layer (gimp-layer-copy invert-layer FALSE))
				)
		    
				(gimp-image-insert-layer image blur-layer ignite-group -1)
				(gimp-item-set-name blur-layer "Final ignite")
				(gimp-layer-set-opacity blur-layer 66.0)
		   
				(plug-in-gmic-qt 1 image (vector blur-layer) 1 0 "fx_blur_dof 3,16,0,0,50,50,1,1,0,1,0,0")
			)

			(gimp-item-set-visible invert-layer FALSE)
		)

		(gimp-item-set-visible contrast-layer FALSE)
	)

	(gimp-progress-set-text "Ignite into a fire: Done.")
	(gimp-displays-flush)
	(gimp-image-undo-group-end image)
	(gimp-progress-end)
)
