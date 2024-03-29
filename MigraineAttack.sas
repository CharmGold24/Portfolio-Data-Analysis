*import data from excel file;
proc IMPORT datatable=ptdetails out=ptdetails dbms=access;
 database="/home/u63789552/DATA_DEPR01.mdb";
run;

*Determine the Average Age of Patients by Gender;
proc tabulate data=ptdetails;
 class sex;
 var age;
 table sex='',(age='')*(n mean)/box='gender';
 keylabel n=N_age;
 keylabel mean=mean_age;
run;

*PROC MEANS To deterine average age of patients;
proc means data=ptdetails;
 class sex;
 var age;
 output out=details(drop=_type_ _freq_) n=n mean=meanage;
run;
proc print;
run;

*Analysis of Smoking and Alcohol;
proc import datatable=history_bk out=history dbms=access;
 database="/home/u63789552/DATA_DEPR01.mdb";
run;
data h1;
 length smoking$ 4. alcohol$ 4.;
 set history;
 keep smoking alcohol;
 if smoking='Y' then smoking='YES';
 if smoking='N' then smoking='NO';
 if alcohol='Y' then alcohol='YES';
 if alcohol='N' then alcohol='NO';
run;
proc print;
run;

proc tabulate data=h1;
 class smoking alcohol;
 table (smoking alcohol)*n;
 run;

*Analysis of Smoking History and Alcohol Consumption;
proc import datatable=history_bk out=history
 dbms=access;
 database="/home/u63789552/DATA_DEPR01.mdb";
run;
data new;
set history;
d=scan(Drintakenperiodofdisc,1,'d');
keep d;
run;
proc print data=new;
run;
data new1;
set new;
nd=input(d,8.);
drop d;
rename nd=d;
run;
proc print;
run;
data his;
set history;
keep smkyncig smkyyears;
run;
proc print;
run;
data his2;
 merge his new1;
run;
proc print;
run;

proc tabulate data=his2;
 var smkyncig smkyyears d;
 table smkyncig smkyyears d,n mean std/box='label';
 label smkyncig=No.of Cigars Smoked smkyyears=No.of Years Smoked
d=No.of Drinks Per Week;
keylabel std=stddev;
run;

/*VISIT1*/
/*ANALYSIS OF CLINICAL EXAMINATION*/
proc import datatable=clinicalexamv1v2 out=clinicalexamv1v2 dbms=access;
 database="/home/u63789552/DATA_DEPR01.mdb";
run;

*Seperating Data - Visit 1 and Visit 2;
options ls=200 pagesize=100;
data vist1 vist2;
set clinicalexamv1v2;
if visit=1 then output vist1; 
else output vist2;
run;
proc print data=vist1 width=minimum noobs;
run;
proc print data=vist2 width=minimum noobs;
run;

/*Determine the Means of Blood Pressure and Pulse Rate*/
data lab1;
	set vist1;
	keep pulse BPSystolic BPDiastolic;
run;
proc tabulate data=lab1;
	var pulse BPSystolic BPDiastolic;
	table pulse BPSystolic BPDiastolic,n mean std/box='label';
	label BPSystolic=Systolic Blood Pressure;
	label BPDiastolic=Diastolic Blood Pressure;
	keylabel std=stddev;
run;

*Summary of Other diseases;
data clinic;
	set vist1;
	keep cardio respiratory abdomen Cns;
run;
proc print width=minimum noobs;
run;
proc tabulate data=clinic;
	class cardio respiratory abdomen cns;
	table Cardio respiratory abdomen cns,n pctn;
	label cns=Central Nervous System;
	keylabel pctn=percent;
run;

/*LAB TESTING*/
/*Analysis of Patient Blood History Data*/
proc import datatable=labtesting out=labtesting 
 dbms=access;
 database="/home/u63789552/DATA_DEPR01.mdb";
run;
data bloodhis;
 set labtesting;
 keep SC Hg Urea Wbc Sodium Neutrophils	Eosinophils	Basophils
 Potassium Lymphocytes Sugar Monocytes Platelets Sb Sgot Sgpt;
run;
proc tabulate data=bloodhis;
 var SC Hg Urea Wbc Sodium Neutrophils Eosinophils Basophils Potassium Lymphocytes Sugar Monocytes
 Platelets Sb Sgot Sgpt;
 table SC Hg Urea Wbc Sodium Neutrophils Eosinophils Basophils Potassium Lymphocytes Sugar Monocytes
 Platelets Sb Sgot Sgpt,n mean std/box='label';
 keylabel std=stddev;
run;

*Summary of Urine Analysis, Pregnancy and ECG;
data upe;
 set labtesting;
 keep urineanalysis urinepregnancy ecg;
run;
proc tabulate data=upe;
 class  urineanalysis urinepregnancy ecg;
 table urineanalysis urinepregnancy ecg,n pctn;
 keylabel pct=percent;
run;

/*MIGRAINE ATTACK*/
/*Averages of Time Since Initial Attack (Months), Frequency and Duration*/
proc import datatable=migraineattackdets out=migraineattackdets
 dbms=access;
 database="/home/u63789552/DATA_DEPR01.mdb";
run;
data migrainattack;
 set  migraineattackdets;
 keep v1attksincemonths V1attkfreqpm V1durationattk;
run;
proc tabulate data=migrainattack;
 var v1attksincemonths V1attkfreqpm V1durationattk;
 table v1attksincemonths V1attkfreqpm V1durationattk, n mean std/box='label';
 label  v1attksincemonths =Time Since Initial Attack (Months);
 label V1attkfreqpm = Frequency Of Attack In A Month;
 label V1durationattk = Duration Of Attack (Hours);
 keylabel std=stddev	;
run;

*Analysis of Side Effects of Migraine Attack;
data migraneattack1;
 set migraineattackdets;
 if v1aura='Y' then v1aura='Yes';
 else v1aura='No';
 if v1nausea='Y' then v1nausea='Yes';
 else v1nausea='No';
 if v1blurvision='Y' then v1blurvision='Yes';
 else v1blurvision='No';
 if v1ptphobia='Y' then v1ptphobia='Yes';
 else v1ptphobia='No';
 if v1pnphobia='Y' then v1pnphobia='Yes';
 else v1pnphobia='No';
run;
proc print width=minimum noobs ;
run;
proc tabulate data=migraneattack1;
 class v1aura v1nausea v1blurvision v1ptphobia v1pnphobia;
 table v1aura v1nausea v1blurvision v1ptphobia v1pnphobia, n pctn;
 label v1aura =aura ;
 label v1nausea  =Nausea  ;
 label v1blurvision=Blurred Vision ;
 label v1ptphobia  =Photophobia;
 label  v1pnphobia=Phonophobia;
run;