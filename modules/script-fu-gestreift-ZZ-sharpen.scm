(script-fu-register-filter "script-fu-gestreift-03-sharpen"
	_"ZZ Sharpen"
	"Sharpens the image via G'MIC (Smooth [Patch-Based] + Sharpen [Octave Sharpening])"
	"Andreas"
	"andreas@gestreift.net"
	"April 2026"
	"*" 
	SF-ONE-DRAWABLE
)

(script-fu-menu-register "script-fu-gestreift-03-sharpen" "<Image>/Filters/gestreift.net")

(define (script-fu-gestreift-03-sharpen
	image
	drawables
	)
	(script-fu-use-v3)

	(if (or (not(vector? drawables)) (not(= (vector-length drawables) 1))) 
		(begin (gimp-message "Please select precisely 1 layer!") (quit 0))
	)

	(gimp-image-undo-group-start image)
    
	(gimp-progress-set-text "Sharpen: Processing ...")

	(let* 	(
			(drawable      (vector-ref drawables 0))
			(drawableName  (gimp-item-get-name drawable))
			(parent        (gimp-item-get-parent drawable))
			(position      (gimp-image-get-item-position image drawable))
        
			(layerBase     (gimp-layer-new-from-visible image image "Sharpened"))
		)

		(gimp-image-insert-layer image layerBase 0 0)
		(plug-in-gmic-qt 1 image (vector layerBase) 1 0 "fx_smooth_patch 6,6,3,5,0,1,1,0,0,24")
		(plug-in-gmic-qt 1 image (vector layerBase) 1 0 "fx_unsharp_octave 5,5,2,0,0,1,24")
       	)

	(gimp-progress-set-text "Sharpen: Done.")
	(gimp-displays-flush)
	(gimp-image-undo-group-end image)
	(gimp-progress-end)
)
