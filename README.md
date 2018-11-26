# UCSB 2018 CS Capstone: InTouch With My Health # 
Company: [InTouch Health](https://intouchhealth.com "InTouch Health Home Website")
<br />
Project Name: Apple Watch x Physicians 

## Team Members ## 
|       Name       |           Email          |
|:----------------:|:------------------------:|
|    Calvin Wang   |   calvin_wang@ucsb.edu   |
|    Vicki Chen    |      vchen@ucsb.edu      |
|   David Halman   |   david_halman@ucsb.edu  |
| Matthew Mitchell | matthewmitchell@ucsb.edu |
|    Henry Jeng    |    henryjeng@ucsb.edu    |

## Project Description ## 
The InTouch operating system provides a simple and reliable communication platform between physicians and patients. Although patient data is collected during a session, to further track a patient's health and enhance current methods of life-saving interventions, data should be collected on a regular basis. With the power of modern wearable devices, vitals can be taken much more often and remotely compared to the occasional hospital visits. 
<br />
<br />
With the newest release of the Apple Watch Series 4, specifically the electrocardiography (ECG) capability, wearable devices take a step further in the direction towards medical appliances. This important feature allows more real time and frequent measurements to be collected and provide physicians supplementary data points, leading to a more accurate diagnosis and treatment for the patient. 
<br />
<br />
For our group project, we will leverage apple watch engineering to integrate medical data including heart rate, ECG, and patient symptoms inside a doctor’s session to provide further clinical data for diagnostic assessment. This will not only provide live data which can alert medical assistants once measurements reach abnormal rates, but the watch integration will also build a health history for each patient that can later be used by the physician.

## Deliverables ##
* Apple watch app + iOS app 
	* capability to send data to InTouch Health platform 
	* Able to prompt user to input symptoms 
	* Live video display
	* Access to all of apple watch’s fitness/health aspects
* IoMT receiving and storage of data 
	* Through their backend 
	* Improvements on data being connected to the IoMT
* Analysis on ECG and heart rate readings
	* UIUX Visuals in dashboard 
	* Potentially some ML for suggestions 

## Solution ## 
In the end, we hope to present an application capable of establishing a two way connection our users with the Intouch Health operating system. Our application will be able to prompt user to input their symptoms, either through voice to text or audio. The application will also receive data from Intouch’s IoMT.

The data collected from the patient’s apple watch will be compiled in a database for health history tabulation and analysis. The patient data, like heart rate readings and ECG, will then be displayed on a beautifully designed web interface for the physician to view. 

## Notes for using the Rails App ##
List of useful commands:
    
* 'bundle install'
    * install all gems
* 'bundle exec rails server'                                      
    * start the local server
* 'RAILS_ENV=production bundle exec rails assets:precompile'      
    * compile the local assets. Do this before deploying the app
* 'gcloud app deploy'                                             
    * upload local code to google cloud 


## Test Criteria for Web App ##
* Should be able to run a local server using 'bundle exec rails server' and build successfully
* Should be able to visit localhost:3000 and have the Webapp appear.
    * The webapp should display using the proper colorscheme of ITH
    * The home page should display a list of patient cards with names and pictures
* Should be able to click on an individual patient card and see extra info about that patient
    * Extra data includes heartrate data
* After deploying using gcloud app deploy, should be able to run 'gcloud app describe' and see that the servingStatus field has value SERVING
* After deploying should visit https://starry-odyssey-221817.appspot.com/ and see that all previous tests for the local server also work on the hosted webapp.  

