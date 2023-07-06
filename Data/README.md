# Data for: Guppies in large groups cooperate more frequently in an experimental test of the group size paradox

## Data files
* all_tracking_data.csv: All trajectory data for each fish, giving its position for each frame of the video, providing a resolution of 25Hz. This file contains the following variables:
* frame -- the frame number
* X -- the x coordinate of the fish (in cm)
* Y -- the y coordinate of the fish (in cm)
* Fish_ID -- the individual fish identification number (unique within but not across trials)
* Group_size -- the group size treatment
* Trial_ID -- the identification code for the trial

* all_binned_data.csv: This file contains trajectory data for each fish; data are aggregated (/'binned') into a 1-second resolution. This file contains the following variables:
* Fish_ID -- the individual fish identification number (unique within but not across trials)
* Second -- the time point (as a second) of the data point
* X -- the x coordinate of the fish (in cm)
* Y -- the y coordinate of the fish (in cm)
* Dist_to_model -- the distance of the fish from the closest point of the predator model (in cm)
* Group_size -- the group size treatment
* Trial_ID -- the identification code for the trial

* all_inspection_data.csv: This file contains individual-level data about inspection behaviour, specifically the number, during, and distance of inspections. This file contains the following variables:
* Fish_ID -- the individual fish identification number (unique within but not across trials)
* Min_dist -- the minimum distance that the individual approached the predator (in cm)
* Time_within_30cm -- the amount of time (in seconds) that an individual spent within 30cm of the predator model
* Total_time -- the total time that the fish was visible to the tracking software (in seconds)
* Proportion_within_30cm -- the proportion of visible time that the fish was within 30cm of the predator model
* Group_size -- the group size treatment
* Trial_ID -- the identification code for the trial
* N_inspections -- the number of inspections

* all_inspection_times_data.csv: This file contains individual-level data about inspection behaviour, specifically the time an individual entered and left the 30cm 'inspection zone'. This file contains the following variables:
* Trial_ID -- the identification code for the trial
* Group_size -- the group size treatment
* Fish_ID -- the individual fish identification number (unique within but not across trials)
* In -- a timestamp (in seconds) that the fish entered within 30cm of the predator model
* Out -- a timestamp (in seconds) that the fish left the 30cm radius of the predator model
* Duration -- the amount of time (in seconds) that the fish spent within 30cm on that occasion

* before_all_tracking_data.csv: All trajectory data for each fish before the introduction of the predator model, giving its position for each frame of the video, providing a resolution of 25Hz. This file contains the following variables:
* frame -- the frame number
* X -- the x coordinate of the fish (in cm)
* Y -- the y coordinate of the fish (in cm)
* Fish_ID -- the individual fish identification number (unique within but not across trials)
* Group_size -- the group size treatment
* Trial_ID -- the identification code for the trial

* before_all_binned_data.csv: This file contains trajectory data for each fish before the introduction of the predator model; data are aggregated (/'binned') into a 1-second resolution. This file contains the following variables:
* Fish_ID -- the individual fish identification number (unique within but not across trials)
* Second -- the time point (as a second) of the data point
* X -- the x coordinate of the fish (in cm)
* Y -- the y coordinate of the fish (in cm)
* Group_size -- the group size treatment
* Trial_ID -- the identification code for the trial

* all_lengths_data.csv:  This file contains data on the length of each fish in each trial. This file contains the following variables:
* Length -- the length of the fish (in cm)
* Date -- the date of the trial (analogous to trial ID since there was one trial per day)

* all_refuge_data.csv: This file contains data on the proportion of time that fish spent in refuges. This file contains the following variables:
* Fish_ID -- the individual fish identification number (unique within but not across trials)
* Total_time -- the number of seconds the fish is visible
* Time_refuge -- the proportion of time spent in the refuge (not visible)
* Group_size -- the group size treatment
* Trial_ID -- the identification code for the trial
* Phase -- whether this was before or during predator stimulus exposure
* pool_temp -- trial pool temperature in degrees C
* fish_length -- mean length of fish in group in cm
* pool_temp_scaled -- pool_temp z-scored
* fish_length_scaled -- fish_length z-scored
* Groupsize_Phase -- group_size * phase interaction group
* Trial_Date -- date of trial in ddmm