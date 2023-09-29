writeInfoLine: "Extracting features..."

## Written by Arian Shamei, Vancouver BC



## Specify pitch range for all files -- note: separate batches by high / low pitch (i.e. male, female)
pitch_floor = 100
pitch_ceiling = 500


##  Specify the directory where your sound files and accompanying textgrids are located:
directory$ = "/Users/arianshamei/Desktop/alzbatchtest/"

##  Specify what file extension your sound files end in (.wav, .aiff...)
extension$ = ".wav"


clearinfo
Create Strings as file list... list 'directory$'*'extension$'
number_of_files = Get number of strings

# Create the output file and write the first line.
outputPath$ = "/Users/arianshamei/Desktop/formantscript.csv"
writeFileLine: "'outputPath$'", "file,time,word,phoneme,F1,F2,F3,F4,F5,med_pitch,mean_pitch,sd_pitch,min_pitch,max_pitch,num_pulse,num_period,mean_period,sd_period,
	...frac_unvoiced,num_voice_break,deg_voice_break,jit_loc,jit_abs,jit_rap,jit_ppq5,jit_ddp,shim_loc,shim_db, shim_apq3,shim_apq5,shim_apq11, shim_dda, mean_autocorr,mean_hnr,mean_sd_hnr"

for a from 1 to number_of_files
	select Strings list
	thisSound$ = Get string... 'a'
	Read from file... 'directory$''thisSound$'
	thisSound$ = selected$("Sound")
	Read from file... 'directory$''thisSound$'.TextGrid
	thisTextGrid$ = selected$("TextGrid")
	numberOfPhonemes = Get number of intervals: 1  
	appendInfoLine: "There are ", numberOfPhonemes, " intervals."

	select Sound 'thisSound$'
	sound = selected("Sound")
	To Formant (burg)... 0 5 5000 0.025 50
	select Sound 'thisSound$'
	pitch = To Pitch (ac): 0, pitch_floor, 15, "yes", 0.03, 0.45, 0.01, 0.35, 0.14, pitch_ceiling
	select Sound 'thisSound$'
	pulses = To PointProcess (periodic, cc)... pitch_floor pitch_ceiling
	select Sound 'thisSound$'
	To Harmonicity (cc)... 0.01 pitch_floor 0.1 1


	
	# Loop through each interval on the phoneme tier.
	for thisInterval from 1 to numberOfPhonemes
		# Get the label of the interval
		select TextGrid 'thisTextGrid$'
		thisPhoneme$ = Get label of interval: 1, thisInterval
		
		# Find the midpoint.
		thisPhonemeStartTime = Get start point: 1, thisInterval
    	thisPhonemeEndTime   = Get end point:   1, thisInterval
    	duration = thisPhonemeEndTime - thisPhonemeStartTime
    	midpoint = thisPhonemeStartTime + duration/2


    	# Extract formant measurements
    	select Formant 'thisSound$'
    	f1 = Get value at time... 1 midpoint Hertz Linear
    	f2 = Get value at time... 2 midpoint Hertz Linear
    	f3 = Get value at time... 3 midpoint Hertz Linear
		f4 = Get value at time... 4 midpoint Hertz Linear
		f5 = Get value at time... 5 midpoint Hertz Linear

		# Voice report
		selectObject: sound, pitch, pulses
  		report$ = Voice report: thisPhonemeStartTime, thisPhonemeEndTime, pitch_floor, pitch_ceiling, 1.3, 1.6, 0.03, 0.45
		med_pitch = extractNumber (report$, "Median pitch: ")
		mean_pitch = extractNumber (report$, "Mean pitch: ")
		sd_pitch = extractNumber (report$, "Standard deviation: ")
		min_pitch = extractNumber (report$, "Minimum pitch: ")
		max_pitch = extractNumber (report$, "Maximum pitch: ")

		num_pulse =  extractNumber (report$, "Number of pulses: ")
		num_period =  extractNumber (report$, "Number of periods: ")
		mean_period =  extractNumber (report$, "Mean period: ")
		sd_period =  extractNumber (report$, "Standard deviation of period: ")

		frac_unvoiced = extractNumber (report$, "Fraction of locally unvoiced frames: ")
		num_voice_break = extractNumber (report$, "Number of voice breaks: ")
		deg_voice_break = extractNumber (report$, "Degree of voice breaks: ") 

		jit_loc = extractNumber (report$, "Jitter (local): ")
		jit_abs = extractNumber (report$, "Jitter (local, absolute): ")
		jit_rap = extractNumber (report$, "Jitter (rap): ")
		jit_ppq5 = extractNumber (report$, "Jitter (ppq5): ")
		jit_ddp = extractNumber (report$, "Jitter (ddp): ")


		shim_loc = extractNumber (report$, "Shimmer (local): ")
		shim_db = extractNumber (report$, "Shimmer (local, dB): ")
		shim_apq3 = extractNumber (report$, "Shimmer (apq3): ")
		shim_apq5 = extractNumber (report$, "Shimmer (apq5): ")
		shim_apq11 = extractNumber (report$, "Shimmer (apq11): ")
		shim_dda = extractNumber (report$, "Shimmer (dda): ")
		
		mean_autocorr =  extractNumber (report$, "Mean autocorrelation: ")
		select Harmonicity 'thisSound$'
		mean_hnr = Get mean... thisPhonemeStartTime thisPhonemeEndTime
		mean_sd_hnr = Get standard deviation... thisPhonemeStartTime thisPhonemeEndTime



    	# Get the word interval and then the label
    	select TextGrid 'thisTextGrid$'
    	thisWordInterval = Get interval at time: 2, midpoint
    	thisWord$ = Get label of interval: 2, thisWordInterval

    	# Save to a spreadsheet
    	appendFileLine: "'outputPath$'", 
		    ...thisSound$, ",",
		    ...midpoint, ",",
		    ...thisWord$, ",",
		    ...thisPhoneme$, ",",
		    ...f1, ",", 
		    ...f2, ",", 
		    ...f3, ",",
		    ...f4, ",",
		    ...f5, ",",
		 	...med_pitch, ",",
		 	...mean_pitch, ",",
		 	...sd_pitch, ",",
		 	...min_pitch, ",",
		 	...max_pitch, ",",
		 	...num_pulse, ",",
		 	...num_period, ",",
		 	...mean_period, ",",
		 	...sd_period, ",",
		 	...frac_unvoiced, ",",
		 	...num_voice_break, ",",
		 	...deg_voice_break, ",",
		 	...jit_loc, ",",
		 	...jit_abs, ",",
		 	...jit_rap, ",",
		 	...jit_ppq5, ",",
			...jit_ppq5, ",",
		 	...shim_loc, ",",
		 	...shim_db, ",",
		 	...shim_apq3, ",",
		 	...shim_apq5, ",",
		 	...shim_apq11, ",",
		 	...shim_dda, ",",
		 	...mean_autocorr, ",",
		 	...mean_hnr, ",",
			...mean_sd_hnr

		endfor
	endfor
