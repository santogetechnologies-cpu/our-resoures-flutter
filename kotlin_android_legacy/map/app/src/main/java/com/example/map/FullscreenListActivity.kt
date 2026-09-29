package com.example.map

import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Intent
import android.graphics.Typeface
import android.os.Build
import android.os.Bundle
import android.text.Layout
import android.text.Spannable
import android.text.SpannableString
import android.text.Spanned
import android.text.style.AlignmentSpan
import android.text.style.ImageSpan
import android.text.style.StyleSpan
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat

class FullscreenListActivity : AppCompatActivity() {
    @SuppressLint("WrongViewCast", "MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // This code will hide the system navigation bar
            window.decorView.systemUiVisibility = (
                    View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                    )
        }


        super.onCreate(savedInstanceState)
        setContentView(R.layout.fullscreen_list)
        supportActionBar?.hide()



        //START: Button 1
        val button1: Button = findViewById(R.id.button1)
        button1.setOnClickListener {
            val fullText = "بسم الله الرحمن الرحيم\n" +
                    "الحمد لله رب العالمين وبعد ...\n" +
                    "تعزيزاً وتحقيقا لرؤية المملكة 2030 في توطين واستثمار الثروات الطبيعية في المملكة وتوفير طاقة نظيفة صديقه للبيئة. قام الفريق العلمي والتقني المكون من:\n" +
                    "أ. د. عبد الله العمري\n" +
                    "م\u200C.\tمشعل ال كدم\n" +
                    "م\u200C.\tعبد العزيز الدحيم\n" +
                    "م\u200C.\tمشاري الجهني\n" +
                    "م. محمد بن عراج\n" +
                    "م. نايف العتيبي\n" +
                    "\n" +
                    "بتوظيف المعطيات والمعلومات الجيولوجية والجيوفيزيائية المتاحة في المملكة لتحقيق أهداف الرؤية من خلال رفع البيانات المعدنية والبترولية والمائية والزلزالية ومعالم السياحة الجيولوجية والآثار على خرائط تفاعلية ثلاثية الأبعاد عالية الدقة والتي تعتبر الأولى من نوعها وذلك لخدمة الجهات ذات العلاقة والباحثين والطلاب للحصول على المعلومة الجيولوجية بكل يسر وسهولة. سوف يقوم الفريق بتحميل الخرائط التفاعلية في الوسائط الاجتماعية والهواتف النقالة على شكل تطبيق.\n" +
                    "وأخيرا لا يسعنا إلا أن نتقدم بخالص الشكر إلى هيئة المساحة الجيولوجية ووزارة البيئة والمياه والزراعة على تزويدنا بالمعلومات المعدنية والمائية والزلزالية بالإضافة إلى الاستفادة من الدراسات وقواعد البيانات المدرجة في موسوعة العمري في علوم الأرض وأطلسي المياه والمعادن.\n" +
                    "رئيس الجمعية السعودية لعلوم الأرض والمشرف على المشروع\n"

            val spannable = SpannableString(fullText)
            val salamStart = fullText.indexOf("بسم الله الرحمن الرحيم")
            val salamEnd = salamStart + "بسم الله الرحمن الرحيم".length

            val nameTitleStart = fullText.indexOf("رئيس الجمعية السعودية لعلوم الأرض والمشرف على المشروع")
            val nameTitleEnd = nameTitleStart + "رئيس الجمعية السعودية لعلوم الأرض والمشرف على المشروع".length


            spannable.setSpan(AlignmentSpan.Standard(Layout.Alignment.ALIGN_CENTER), salamStart, salamEnd, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
            spannable.setSpan(AlignmentSpan.Standard(Layout.Alignment.ALIGN_CENTER), nameTitleStart, nameTitleEnd, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)

            spannable.setSpan(StyleSpan(Typeface.BOLD), salamStart, salamEnd, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
            spannable.setSpan(StyleSpan(Typeface.BOLD), nameTitleStart, nameTitleEnd, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)


            showDialogWithText2(spannable, "أ. د. عبد الله بن محمد العمري", R.drawable.sign)

        }
        //END: Button 1

        // START: button2
        val saudigeo: Button = findViewById(R.id.button2)
        saudigeo.setOnClickListener {
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
        }
        // END: button2

        // START: Water formation
        val waterFormation: Button = findViewById(R.id.waterFormarion)
        waterFormation.setOnClickListener {
            val intent = Intent(this, WaterFormations::class.java)
            startActivity(intent)
        }
        // END: Water formation


        // START: Oil and Gas
        val oil: Button = findViewById(R.id.oil)
        oil.setOnClickListener {
            val intent = Intent(this, OilGas::class.java)
            startActivity(intent)
        }
        // END: Oil and Gas

        // START: materials
        val materials: Button = findViewById(R.id.materials)
        materials.setOnClickListener {
            val intent = Intent(this, MaterialsActivity::class.java)
            startActivity(intent)
        }
        // END: materials

        // START: earthquakes
        val earthquakes: Button = findViewById(R.id.earthquakes)
        earthquakes.setOnClickListener {
            val intent = Intent(this, EarthquakeActivity::class.java)
            startActivity(intent)
        }
        // END: earthquakes

        // START: Button 7
        val tourism: Button = findViewById(R.id.button7)
        tourism.setOnClickListener {
            val intent = Intent(this, TourismActivity::class.java)
            startActivity(intent)
        }
        // END: Button 7

        // START: Button 8
        val button8: Button = findViewById(R.id.button8)
        button8.setOnClickListener {
            val fullText = "المصادر\n" +
                    "\n" +
                    "اطلس المياه (1984). وزارة الزراعة والمياه- المملكة العربية السعودية-\n" +
                    "الرياض – 111 صفحة.\n" +
                    "اطلس المعادن الصناعية (2016). وكالة وزارة الطاقة والصناعة للثروة\n" +
                    "المعدنية – جده - 130 صفحة.\n" +
                    "الثروات المعدنية في المملكة العربية السعودية (2016). وكالة وزارة الطاقة\n" +
                    "والصناعة للثروة المعدنية – جده.\n" +
                    "قاعدة البيانات المعدنية والزلزالية (2023) - هيئة المساحة الجيولوجية –\n" +
                    "جده.\n" +
                    "موسوعة العمري في علوم الأرض - 30 كتاب ( 2023). الجمعية السعودية\n" +
                    "لعلوم الأرض- الرياض.\n" +
                    "\n" +
                    "Development of Mineral Exploration in the Kingdom of Saudi\n" +
                    "Arabia (1999), Ministry of Petroleum and Minerals, Saudi Arabia.\n" +
                    "Hamimi, Z., Fowler, A., Liégeois, J., Collins, A., Abdelsalam, M.,\n" +
                    "Abd EI-Wahed , M. (Editors). The Geology of the Arabian-Nubian\n" +
                    "Shield, 2021, 786 P., Springer Nature Switzerland.\n" +
                    "Powers, R.W.; Ramirez, Leon F.; Redmond, C.D.; Elberg, E.L. Jr.\n" +
                    "(1963). Geology of the Arabian Peninsula: Sedimentary Geology of " +
                    "Saudi Arabia. USGS, PP 560-D, Washington, USA."

            val spannable = SpannableString(fullText)
            val startIndex = fullText.indexOf("المصادر")
            val endIndex = startIndex + "المصادر".length
            spannable.setSpan(AlignmentSpan.Standard(Layout.Alignment.ALIGN_CENTER), startIndex, endIndex, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)

           showDialogWithText( spannable)

        }
        // END: Button 8

    }

    private fun showDialogWithText2(spannableText: SpannableString, afterImageText: String, imageResId: Int) {
        val dialog = Dialog(this)
        dialog.setContentView(R.layout.about_the_map)

        // Set the SpannableString to the first TextView
        val textViewBeforeImage: TextView = dialog.findViewById(R.id.dialog_text_view)
        textViewBeforeImage.text = spannableText

        // Set the second part of the text to the second TextView
        val textViewAfterImage: TextView = dialog.findViewById(R.id.endName)
        textViewAfterImage.text = afterImageText

        // Set the image to the ImageView
        val imageView: ImageView = dialog.findViewById(R.id.signImage)
        imageView.setImageResource(imageResId)

        dialog.show()
    }


    private fun showDialogWithText(text: SpannableString) {
        val dialog = Dialog(this)
        dialog.setContentView(R.layout.about_the_map) // Ensure you have a TextView with id 'dialog_text_view' in this layout
        val textView: TextView = dialog.findViewById(R.id.dialog_text_view)
        textView.text = text
        dialog.show()
    }

}

