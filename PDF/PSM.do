* 1. สร้างนิยามของป้ายชื่อ (Label define)
label define yesno_lab 0 "No" 1 "Yes"
label define sex_lab 0 "Female" 1 "Male"

* 2. นำป้ายชื่อไปแปะที่ตัวแปร (Label values)
label values anaemia diabetes high_blood_pressure smoking death_event yesno_lab
label values sex sex_lab

* 3. เช็กผลลัพธ์
tabulate high_blood_pressure

** พรรณา
dtable, by(high_blood_pressure, test total) ///
    continuous(age creatinine_phosphokinase ejection_fraction platelets serum_creatinine serum_sodium time, statistics(p50 p25 p75) test(kwallis)) ///
    factor(anaemia diabetes smoking death_event sex, statistics(fvfreq fvpercent) test(pearson)) ///
    nformat(%9.2f p50 p25 p75 fvpercent) 

**การจับคู่ด้วยคะแนนความน่าจะเป็น (PSM Execution)
**รัน psmatch2 เพื่อจับคู่กลุ่ม (Control vs Treatment)
* (ใช้ high_blood_pressure เป็น Treatment และ DEATH_EVENT เป็น Outcome)
psmatch2 high_blood_pressure age anaemia creatinine_phosphokinase diabetes ejection_fraction platelets serum_creatinine serum_sodium sex smoking, outcome(death_event) logit

**การตรวจสอบความสมดุลของการจับคู่ (Balance Check)
pstest age anaemia creatinine_phosphokinase diabetes ejection_fraction platelets serum_creatinine serum_sodium sex smoking, both graph

* สั่งทำกราฟจุดเพื่อดูความต่าง (Standardized Mean Difference)
pstest age anaemia creatinine_phosphokinase diabetes ejection_fraction platelets serum_creatinine serum_sodium sex smoking, graph

**การแสดงผลกราฟิก (Visualization)
psgraph


* เพิ่มออปชัน caliper(0.05) และ common
psmatch2 high_blood_pressure age anaemia creatinine_phosphokinase diabetes ejection_fraction platelets serum_creatinine serum_sodium sex smoking, outcome(death_event) logit 


* วาดกราฟภูเขา (Density Plot) แยก 2 กลุ่ม
twoway (kdensity _pscore if high_blood_pressure==1, color(red%50) recast(area)) ///
       (kdensity _pscore if high_blood_pressure==0, color(blue%50) recast(area)), ///
       legend(order(1 "High BP (Treatment)" 2 "Normal (Control)")) ///
       xtitle("Propensity Score") ytitle("Density") ///
       title("Propensity Score Distribution (Mountain Plot)")

	   
