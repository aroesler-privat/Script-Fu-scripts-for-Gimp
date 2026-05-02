; Ebene duplizieren -> " (Temperature)" anhängen, Deckkraft 80%
;                   -> G'MIC -> Temperature Balance
; Ebene duplizieren -> " (Brightness+Temperature) anhängen, Deckkraft 80%
;                   -> G'MIC -> Normalize Brightness

(script-fu-register-filter "script-fu-gestreift-02-temperature"
	_"02 Temperature & Brightness"
	"Balancing the color temperature and normalizing the brightness via G'MIC"
	"Andreas"
	"andreas@gestreift.net"
	"April 2026"
	"*" 
	SF-ONE-DRAWABLE
)

(script-fu-menu-register "script-fu-gestreift-02-temperature" "<Image>/Filters/gestreift.net")

(define (script-fu-gestreift-02-temperature image drawables)
	(script-fu-use-v3)

	(if (or (not(vector? drawables)) (not(= (vector-length drawables) 1))) 
		(begin (gimp-message "Please select precisely 1 layer!") (quit 0))
	)

	(gimp-image-undo-group-start image)
    
	(gimp-progress-set-text "Temperature & Brightness: Processing ...")

	(let* 	(
			(drawable      (vector-ref drawables 0))
			(drawableName  (gimp-item-get-name drawable))
			(parent        (gimp-item-get-parent drawable))
			(position      (gimp-image-get-item-position image drawable))

			(base-group (gimp-group-layer-new image "Temperature & Brightness"))
			(temp-layer (gimp-layer-new-from-visible image image "Temperature Balance"))
		)

		(gimp-image-insert-layer image base-group 0 0)

		(gimp-image-insert-layer image temp-layer base-group -1)
		(plug-in-gmic-qt 1 image (vector temp-layer) 1 0 "gcd_temp_balance 0,0,1.208,0")
		(gimp-layer-set-opacity temp-layer 80.0)
        
		(let* 	(
			 	(bright-layer (gimp-layer-new-from-visible image image "Normalize Brightness"))
			)
            
			(gimp-image-insert-layer image bright-layer base-group -1)
			(plug-in-gmic-qt 1 image (vector bright-layer) 1 0 "gcd_normalize_brightness 0,50.9,0,3,0,0")
			(gimp-layer-set-opacity bright-layer 80.0)
		)
	)

	(gimp-progress-set-text "Temperature & Brightness: Done.")
	(gimp-displays-flush)
	(gimp-image-undo-group-end image)
	(gimp-progress-end)
)
