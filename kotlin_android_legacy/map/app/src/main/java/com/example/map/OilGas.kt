package com.example.map

import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.CameraOptions
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions
import com.mapbox.maps.plugin.annotation.generated.OnPointAnnotationClickListener
import com.mapbox.maps.plugin.annotation.generated.PointAnnotation
import com.mapbox.maps.plugin.annotation.generated.createPointAnnotationManager

class OilGas : AppCompatActivity(), OnPointAnnotationClickListener {

    data class LocationMarker(
        val latitude: Double,
        val longitude: Double,
        val title: String,
        val description: String,
    )

    private lateinit var mapView: MapView
    private lateinit var mapboxMap: MapboxMap
    private lateinit var pointAnnotationManager: PointAnnotationManager
    private val annotationDataMap = HashMap<Long, LocationMarker>()

    @SuppressLint("UseCompatLoadingForDrawables", "InflateParams", "SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // This code will hide the system navigation bar
            window.decorView.systemUiVisibility = (
                    View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                    )
        }


        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_oil_gas)
        supportActionBar?.hide()

        //START: Back button
        val homeBtn: FloatingActionButton = findViewById(R.id.home)
        homeBtn.setOnClickListener {
            onBackPressed()
        }
        //END: Back button

        //START: Brief button
        val brief: Button = findViewById(R.id.brief)
        brief.setOnClickListener {
            // Inflate the popup view
            val popupView = LayoutInflater.from(this).inflate(R.layout.popup_brief, null)
            popupView.findViewById<TextView>(R.id.title).text = "حقول البترول والغاز"
            popupView.findViewById<TextView>(R.id.description).text = "يتكون النفط والغاز في باطن الأرض بنفس الظروف الطبيعية، وعادةً ما يتواجدان في حقلٍ واحدٍ، إلا أنه يمكن إيجاد حقول للغاز منفردة، والفرق بين تكوين النفط والغاز الطبيعي هو الاختلاف في تعرضهما لدرجة حرارة، فالنفط عادة ما يكون على عمق 1000 م إلى 6000 م أما إذا تكوّن النفط على عمق أكبر فإن درجة الحرارة التي يتعرض لها تكون أكبر فهنا يتحول النفط إلى غاز، وكلما زاد عمق تكوّن النفط كلّما تحوّل إلى غاز أكثر نقاءً إذ يكون من نوع الغاز الجاف الذي تنخفض به المواد العالقة، فبعد تكوّنه غازاً يبدأ بالتسرّب إلى طبقات القشرة الأرضية، وعند اصطدامه بطبقة صخرية قاسية قليلة المسامية تعمل على منع تسربه فإنّه ينحبس في هذه المصائد. وحيث أن البترول و الغاز الطبيعي كلاهما أخف من الماء و أقل كثافة من الصخور المحيطة فإنهما ينتقلان لأعلى عبر القشرة الأرضية لمسافات طويلة أحياناً و في النهاية تُـحبس بعض هذه المواد الهيدروكربونية المنتقلة لأعلى في طبقة لا مسامية (غير منفذة للماء) من الصخور تُعرف بـ صخور الغطاء (Cap Rock).. ولأن الغاز الطبيعي أخف من البترول فيقوم بتكوين طبقة فوق البترول تسمى غطاء الغاز  (Gas Cap)  ولا بد أن يصاحب البترول غاز يسمى بـ الغاز المصاحِب ” APG “ وهو شكل من أشكال الغاز الطبيعي ويوجد مع مستودعات النفط ويكون إما مذوب في النفط أو كقبة غازية فوق النفط في المستودع.\n" +
                    "يمر النفط بمراحل عدة خلال تكونه وهي: المرحلة الأولى: كانت المسطحات المائية من بحارٍ ومحيطاتٍ غنيةٍ بالطحالب والأحياء البحرية الدقيقة فعند موتها ترسبت هذه المواد في أسفل البحار، ومع مرور الزمن تكوّنت فوقها طبقة رسوبية سميكة مما عرّض هذه المواد إلى الضغط الشديد، وهذا الضغط تسبّب بارتفاع درجة حرارتها، فتحللت هذه المواد لتصبح مواد سائلةً ترتفع بها نسبة الكربون (هيدروكربونية). المرحلة الثانية: مرحلة هجرة المواد السائلة من مناطق تكوّنها، إذ تكون واقعةً تحت ضغطٍ شديدٍ، فتتسرّب إلى مناطق أقل ضغطاً عبر مسامات وشقوق وكسور الصخور المحيطة فيها ويكون هذا التسرب إما تسرباً لأفقياً وإما تسرباً عمودياً. المرحلة الثالثة: وهي مرحلة تجمع السائل المتسرّب، فيتجمع هذا السائل في طبقات الصخور الرسوبية إذ تعمل هذه الطبقة على امتصاصه بسبب وجود الفراغات أو المسامات بين جزيئاتها، فتعمل كقطعة إسفنج تجذب السائل إليها، وعادةً ما تكون هذه الطبقة الصخرية الرسوبية فوق طبقة صخرية ناريةٍ فتمنع تسرّب السائل منها إذ تعمل كحاجزٍ في أسفل الطبقات الرسوبية، وتسمّى هذه الحالة مكامن أو مصيدة النفط، ويختلف العمق الذي تكون فيه هذه المصائد من منطقة إلى أخرى حسب قربه أو بعده عن مكان تكونه وكذلك حسب التركيب الصخري للمنطقة. \n" +
                    "يُعرّف الغاز الطبيعي بأنّه أحد مصادر الطاقة الأحفورية التي تُستخرج من باطن الأرض، ويدخل الغاز الطبيعي في صناعات الوقود والعديد من المواد الكيميائية الأخرى، ويتكون الغاز الطبيعي من بعض المكونات الكيميائية، وأهمّها \n" +
                    "غاز الميثان: وهو مركب كيميائي يتكون من ذرة كربون واحدة و4 ذرات هيدروجين، ويُعرف بالصيغة الكيميائية (CH4)، ويُعدّ المكوّن الأكبر للغاز الطبيعي، غاز شديد الاحتراق ويستخدم في توليد الكهرباء باستخدام توربينات الغاز والبخار، كما يُستخدم في المنازل بهدف الطهي، والتدفئة، والتكييف. غاز الإيثان: ثاني أهم مكّون للغاز الطبيعي، وهو مُركب هيدروكربوني يتشكّل من الهيدروجين والكربون، عديم اللون والرائحة وينتمي إلى سلالة البرافين، ويُعد الإيثان أبسط أنواع المركبات الهدروكربونية، وله رابطة كربون-كربون واحدة وصيغته الكيميائية (C2H6)، وعادةً ما يظهر بعد عمليات إعادة تكرير النفط وحرق الفحم. غاز البيوتان أو البوتان: يُعدّ غاز البيوتان أحد الغازات الهيدروكربونية القليلة التي تدخل في مكونات الغاز الطبيعي، إذ يُشكّل ما نسبته 20% من إجمالي مكونات الغاز الطبيعي، يدخل في صناعة الغاز الذي يستخدم كوقود للسيارات، وغاز التبريد  وغيرها من الاستخدامات، ويُصنّف غاز البيوتان كأحد الغازات الضارة للبيئة. غاز البروبان: يُعدّ غاز البروبان أحد أنواع الغازات المُكونة للغاز الطبيعي، وصيغته الكيميائية (C3H8).\n"

            popupView.findViewById<ImageView>(R.id.image).setImageResource(R.drawable.oil_brief)

            val briefDialog = Dialog(this)
            briefDialog.setContentView(popupView)

            val displayMetrics = resources.displayMetrics
            val screenWidth = displayMetrics.widthPixels

            briefDialog.window?.setLayout(
                (screenWidth * 0.8).toInt(),
                LinearLayout.LayoutParams.WRAP_CONTENT
            )

            briefDialog.show()

            val closeButton = popupView.findViewById<Button>(R.id.closeButton)
            closeButton.setOnClickListener {
                briefDialog.dismiss()
            }
        }
        //END: Brief button


        mapView = findViewById(R.id.mapView)
        mapboxMap = mapView.getMapboxMap()

        // Set initial map style from your custom JSON
        setMapStyle("maps/saudi_geo/sahel.json")

        pointAnnotationManager = mapView.annotations.createPointAnnotationManager().apply {
            addClickListener(this@OilGas)
        }


        // Set initial camera position
        val initialPosition = CameraOptions.Builder()
            .center(Point.fromLngLat(47.189224, 24.694291))
            .zoom(4.3)
            .build()
        mapboxMap.setCamera(initialPosition)

        val resetZoomBtn: FloatingActionButton = findViewById(R.id.reset_zoom)
        resetZoomBtn.setOnClickListener {
            mapboxMap.setCamera(initialPosition)
        }

    }

    private fun addMarkerWithPopup(marker: LocationMarker, iconImageId: String) {
        val point = Point.fromLngLat(marker.longitude, marker.latitude)
        val pointAnnotationOptions = PointAnnotationOptions()
            .withPoint(point)
            .withIconImage(iconImageId)
            .withIconSize(0.2) // icon size

        val annotation = pointAnnotationManager.create(pointAnnotationOptions)
        annotationDataMap[annotation.id] = marker
    }


    override fun onAnnotationClick(annotation: PointAnnotation): Boolean {
        val markerData = annotationDataMap[annotation.id]
        if (markerData != null) {
            showPopup(markerData.title, markerData.description)
        }
        return true
    }

    @SuppressLint("InflateParams")
    private fun showPopup(title: String, description: String) {
        val popupView = LayoutInflater.from(this).inflate(R.layout.popup_layout, null)
        popupView.findViewById<TextView>(R.id.title).text = title
        popupView.findViewById<TextView>(R.id.description).text = description

        val dialog = Dialog(this)
        dialog.setContentView(popupView)

        val displayMetrics = resources.displayMetrics
        val screenWidth = displayMetrics.widthPixels

        dialog.window?.setLayout((screenWidth * 0.4).toInt(), LinearLayout.LayoutParams.WRAP_CONTENT)

        dialog.show()

        val closeButton = popupView.findViewById<Button>(R.id.closeButton)
        closeButton.setOnClickListener {
            dialog.dismiss()
        }
    }


    private fun setMapStyle(assetPath: String) {
        val styleJson = loadJsonFromAsset(assetPath)
        mapboxMap.loadStyleJson(styleJson) { style ->

            // oil icon
            val markerIconDrawable = ContextCompat.getDrawable(this, R.drawable.oil_marker)
            markerIconDrawable?.let {
                val markerIconBitmap = drawableToBitmap(it)
                style.addImage("marker-icon-id", markerIconBitmap)
            }

            //gas icon
            val gasMarkerIconDrawable  = ContextCompat.getDrawable(this, R.drawable.gas_marker)
            gasMarkerIconDrawable?.let {
                val gasMarkerIconBitmap = drawableToBitmap(it)
                style.addImage("gas-marker-icon-id", gasMarkerIconBitmap) // Use a different ID for the gas marker
            }


            // markers - oil markers
            val markers = listOf(

                LocationMarker(
                    25.141366,
                    49.557756,
                    "حقل الغوار",
                    "جاءت تسمية الحقل بالغوّار من الكلمة العربية )غَارَ( التي تعني شديد العمق، أو البعيد في باطن الأرض.\n" +
                            "حقل نفط سعودي في محافظة الأحساء، بالمنطقة الشرقية ويبلغ قياس أبعاده 280 كم في 30 كم، وهو أكبر حقل نفط تقليدي في العالم حيث يصل احتياط النفط فيه إلى حوالي 5 مليار طن، بينما يبلغ متوسط عمق الحفرة التي يستخرج منها النفط فيه إلى حوالي 33 متر. أكتشف عام 1948م. صخور المصدر هي تكوين حنيفة الجوراسي. صخور المكمن أحجار جيرية من العصر الجوراسي،  قُسّم الغوار إلى خمس مناطق إنتاج، من الشمال إلى الجنوب: عين دار وشدقم والعثمانية والحوية وحرض. يحتوي الجزء الشمالي على نفط خفيف الكثافة، ويصل طبقات هذا الجزء إلى حوالي 49 متر، أما القسم الجنوبي، فكلما تقدمنا نحو الجنوب كلما كان النفط أقل كثافةً، وطبقاته أرقّ."
                    ),

                LocationMarker(
                    25.069444,
                    48.195000,
                    "حقل خريص",
                    "حقل خريص يبعد 150 كم شمال شرق الرياض . بطول 127 كم. أكتشف عام 1957م. صخور المصدر هي تكوين القصيبة. صخور المكمن أحجار جيرية من العصر الجوراسي. ينتج هذا الحقل 1.2 مليون برميل يومياً"
                ),

                LocationMarker(
                    24.357939,
                    50.876248,
                    "حقل اللغفة",
                    "يبعد هذا الحقل 500 كم جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار جيرية من العصر الجوراسي) وصخور المصدر من صخور الحنيفة وجبل طويق (أحجار جيرية من العصر الجوراسي)."
                ),

                LocationMarker(
                    24.300065,
                    50.8244,
                    "حقل الجوب",
                    "يبعد هذا الحقل 500 كم من جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار جيرية من العصر الجوراسي) و صخور المصدر من صخور الحنيفة و جبل طويق (أحجار جيرية من العصر الجوراسي)."
                ),

                LocationMarker(
                    22.74347,
                    52.637144,
                    "حقل الشطفة",
                    "يقع الحقل في صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. صخور المكمن من الشعيبة (أحجار جيرية من العصر الجوراسي). صخور متكون الوسيع هي الصخور الحاجزة ( Seal )."
                ),


                LocationMarker(
                    22.477833,
                    54.843267,
                    "حقل الشيبة",
                    "يقع الحقل شرقي صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. أكتشف عام 1968م. في عام 1998 بدأت شركة أرامكو إنتاج البترول. يمكن أن يضخ حقل الشيبة مليون وثلاث مائة ألف برميل يوميًا لمدة 70 عامًا.  صخور المكمن من الشعيبة (أحجار جيرية من العصر الجوراسي). صخور متكون الوسيع هي الصخور الحاجزة (Seal )."
                ),

                LocationMarker(
                    22.252042,
                    54.093359,
                    "حقل الرملة",
                    "يقع الحقل شرقي صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. أكتشف عام 1974م.  صخور المكمن أحجار جيرية من العصر الجوراسي. صخور متكون الوسيع هي الصخور الحاجزة ( Seal )"
                ),


                LocationMarker(
                    23.8088,
                    46.87332,
                    "حقل الحوطة",
                    "يقع الحقل شرقي صحراء الربع الخالي ويبعد 180 كم جنوب الرياض. أكتشف عام 1988م . صخور المكمن من متكون عنيزة (أحجار رملية من العمر الكربوني البيرمي). يتكون الحقل من زيت عربي خفيف ممتاز وقد بلغ الإنتاج الاختباري للبئر الأول 8 آلاف برميل يوميًا عند اكتشافه بينما ينتج حاليًا 200 ألف برميل، وكثافته 49.9 درجة على حسب مقياس معهد البترول الأمريكي."
                ),

                LocationMarker(
                    25.936694,
                    49.602634,
                    "حقل بقيق",
                    "حقل نفط سعودي في محافظة الأحساء، بالمنطقة الشرقية.  أكتشف عام 1940م. صخور المصدر هي تكوين حنيفة الجوراسي. صخور المكمن أحجار جيرية من العصر الجوراسي. يحتوي حقل بقيق على معمل لمعالجة الزيت الخام، ومعمل لمعالجة الغاز الطبيعي. ومعامل توليد الطاقة الكهربائية، وإنتاج البخار وتحلية المياه. ومعامل ضخ الزيت وتنقية وضغط الهواء. يمثّل إنتاج معامل حقل بقيق نحو 6% من إجمالي استهلاك المشتقات النفطية العالمي، في حين يُقدّر إجمالي الاحتياطيات المؤكدة في الحقل بنحو 22.5 مليار برميل. يحظى حقل بقيق بأهمية خاصة على المستوى الدولي، إذ إنه يربط بين السعودية والبحرين من خلال خط أنابيب تأسس عام 1945 بطول 110 كيلومترات، كما تبلغ سعته الإجمالية 350 ألف برميل من النفط الخام يوميًا."
                ),


                LocationMarker(
                    28.211935,
                    48.751281,
                    "حقل السفانية",
                    "يقع حقل السفانية في مياه الخليج العربي على بعد نحو 265 كيلومترا شمال مقر شركة أرامكو في الظهران. وهو أكبر حقل نفطي مغمور تحت الماء في العالم، تصل مساحته إلى 50 كيلو مترا طولا و15 كيلو مترا عرضا. أكتشف عام 1951 م. صخور المكمن من متكون السفانية (أحجار رملية من العصر الكريتاسي) وصخور المصدر من متكون جبل طويق من العصر الجوراسي. يعتبر ثالث أكبر حقل نفط في العالم من حيث الإنتاج، حيث ينتج حوالي 1.5 مليون برميل في اليوم."
                ),

                LocationMarker(
                    27.704328,
                    48.875146,
                    "حقل منيفة",
                    "حقل منيفة هو حقل نفط مغمور، وخامس أكبر حقول النفط في العالم. وأحد أقدم الحقول البحرية النفطية. يقع في المياه الإقليمية للمملكة العربية السعودية على الخليج العربي، على بعد قرابة 110 كلم شمال مدينة الظهران. أكتشف عام 1957 م. صخور المكمن من متكون منيفة (أحجار جيرية من العصر الجوراسي). تصل مساحة الحقل المكون من 6 مكامن، إلى نحو 45 كيلومترًا طولاً، و18 كيلومترًا عرضًا. تصل طاقة حقل منيفة الإنتاجية بعد تطويره إلى 900 ألف برميل من الزيت العربي الثقيل يوميًا."
                ),

                LocationMarker(
                    27.704328,
                    49.603264,
                    "حقل البري",
                    "حقل البري هو حقل نفطي تديره شركة أرامكو السعودية، يقع جنوب محافظة الجبيل نتج الحقل 250 ألف برميل من النفط الخام العربي الخفيف يوميًا. ويتكون الحقل من منطقتين إحداهما على اليابسة والأخرى على البحر. صخور المكمن من متكون الحنيفة (أحجار جيرية من العصر الجوراسي). يبلغ حجم احتياطي النفط العربي الخام فيه ما يزيد عن 15 مليار برميل."
                    ),

                )

            //  Gas markers
            val gasMarkers = listOf(

                LocationMarker(
                    28.18108,
                    34.858831,
                    "حقل مدين",
                    "حقل غاز طبيعي يقع في رأس الشيخ حميد ويبعد حوالي 200 كيلومتر عن منطقة تبوك. أكتشف عام 1990م.يعتمد الحقل على عملية الإنتاج للغاز غير المصاحب. "
                ),

                LocationMarker(
                    28.18108,
                    34.858831,
                    "حقل برقان",
                    "يقع الحقل في الشمال الغربي من البحر الأحمر ويبعد عن تبوك 150 كلم. أكتشف عام 1969م. المكمن من صخور متكون البرقان (أحجار رملية من عصر الميوسين)"
                ),

                LocationMarker(
                    23.439367,
                    46.722663,
                    "حقل الحلوة",
                    "يبعد هذا الحقل 140 كم جنوب الرياض  وأكتشف عام 1990م. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون عنيزة (أحجار رملية من العصر البيرمي) وصخور المصدر من صخور القصيبة (أحجار من العصر السليوري)"
                ),

                LocationMarker(
                    24.105692,
                    49.020345,
                    "حقل شمعة",
                    "يبعد هذا الحقل 500 كم جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار رملية من العصر البيرمي) وصخور المصدر من صخور القصيبة من العصر السليوري."
                ),

                LocationMarker(
                    22.359301,
                    53.130374,
                    "حقل الكدن الشمالي",
                    "يقع الحقل في صحراء الربع الخالي ويبعد 700 كم جنوب شرق الرياض. أكتشف عام 1967م. صخور المكمن من متكون الجلة (أحجار جيرية من العصر الترياسي). "
                ),

                LocationMarker(
                    21.826041,
                    53.135559,
                    "حقل الكدن الجنوبي",
                    "يقع الحقل شرقي صحراء الربع الخالي ويبعد 750 كم جنوب شرق الرياض. أكتشف عام 1968م.  صخور المكمن من متكون الجلة (أحجار جيرية من العصر الترياسي). "
                ),

                LocationMarker(
                    0.0,
                    0.0,
                    "حقل حيران",
                    "يقع في منطقة الربع الخالي بالمملكة على مساحة تتجاوز 600 ألف كيلومتر مربع.     يتدفق  الغاز من مكمن \"حنيفة\" في بئر (الحيران - 1) بمعدل 30 مليون قدم مكعبة قياسية في اليوم، و 1600 برميلٍ من المكثفات، بالإضافة إلى تدفق الغاز من مكمن \"العرب – ج\" في الحقل نفسه بمعدل 3.1 مليون قدم مكعبة قياسية في اليوم."
                ),

                LocationMarker(
                    0.0,
                    0.0,
                    "حقل الشرفة",
                    " مجاور لحقل الحيران في منطقة الربع الخالي، إذ يقع على بُعد 120 كيلومترًا جنوب غرب حقل الشيبة، ويحتوي على بئر واحدة للغاز الطبيعي، وهي \"الشرف - 2\"، يتدفّق منها الغاز بمعدل 16.9 مليون قدم مكعبة يوميًا، مع 50 برميلًا من المكثفات."
                ),

                LocationMarker(
                    21.155611,
                    52.522044,
                    "حقل المحاكيك",
                    "يقع حقل المحاكيك للغاز الطبيعي بمنطقة الربع الخالي السعودية، والتي تمتد على مساحة تبلغ نحو 600 ألف كيلومتر مربع . يتدفق الغاز من بئر المحاكيك – 2 بمعدل 0.85 مليون قدم مكعبة قياسية في اليوم."
                ),


                LocationMarker(
                    0.0,
                    0.0,
                    "حقل عسيكرة",
                    "يقع حقل عسيكرة في مكمن \"الجله\" في الربع الخالي، يتدفق الغاز بمعدل 46 مليون قدم مكعبة قياسية في اليوم."
                ),


                LocationMarker(
                    24.388763,
                    48.312905,
                    "حقل شدون",
                    "يقع غرب مركز حرض، حيث اكتُشِف الغاز الطبيعي في مكمن \"عنيزة – أ\" بعد أن تدفق الغاز بمعدل 15.5 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 460 برميلاً من المكثفات."
                ),


                LocationMarker(
                    24.486152,
                    48.672641,
                    "حقل الوضيحي",
                    "أكتشف في مكمن \"الصارة\" حيث تدفق الغاز الطبيعي بمعدل 11.7 مليون قدم مكعبة قياسية في اليوم."
                ),


                LocationMarker(
                    24.715138,
                    48.878095,
                    "حقل أوتاد",
                    "أكتشف الغاز الطبيعي في مكمن \"القصيباء\" جنوب غرب مدينة الهفوف، حيث تدفق الغاز بمعدل 5.1 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 57 برميلاً يومياً من المكثفات."
                ),

                LocationMarker(
                    24.510276,
                    48.467188,
                    "حقل مزاليج",
                    "اكتشاف الغاز الطبيعي في مكمن \"عنيزة ب/ج\" في حقل \"مزاليج\" جنوب غرب الظهران، حيث تدفق الغاز بمعدل 14 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 4150 برميلاً يومياً من المكثفات."
                ),

                )

            markers.forEach { addMarkerWithPopup(it, "marker-icon-id") } // Oil marker icon

            gasMarkers.forEach { addMarkerWithPopup(it, "gas-marker-icon-id") } // Gas marker icon

            //START: Data buttons
            fun locationBtn(buttonId: Int, mapboxMap: MapboxMap, markers: List<LocationMarker>) {
                val nameButton: Button = findViewById(buttonId)
                nameButton.setOnClickListener {
                    val targetMarker = markers.firstOrNull { it.title == nameButton.text }
                    targetMarker?.let { marker ->
                        // Show popup
                        showPopup(marker.title, marker.description)

                        if (marker.latitude > 0.0 ) {
                            val cameraPosition = CameraOptions.Builder()
                                .center(Point.fromLngLat(marker.longitude, marker.latitude))
                                .zoom(10.0)
                                .build()

                            mapboxMap.setCamera(cameraPosition)
                        }
                    }
                }
            }

            val oil = findViewById<TextView>(R.id.oil)
            val oilList = findViewById<LinearLayout>(R.id.oil_list)
            oil.setOnClickListener {
                if (oilList.visibility == View.GONE) {
                    oilList.visibility = View.VISIBLE
                } else {
                    oilList.visibility = View.GONE
                }
                locationBtn(R.id.gawar, mapboxMap, markers)
                locationBtn(R.id.korais, mapboxMap, markers)
                locationBtn(R.id.lgbah, mapboxMap, markers)
                locationBtn(R.id.jub,  mapboxMap, markers)
                locationBtn(R.id.shatfah,  mapboxMap, markers)
                locationBtn(R.id.shaibah,  mapboxMap, markers)
                locationBtn(R.id.ramlah,  mapboxMap, markers)
                locationBtn(R.id.hota,  mapboxMap, markers)
                locationBtn(R.id.buqaiq,  mapboxMap, markers)
                locationBtn(R.id.sofiniah,  mapboxMap, markers)
                locationBtn(R.id.munifiah,  mapboxMap, markers)
                locationBtn(R.id.bury,  mapboxMap, markers)
            }

            val gas = findViewById<TextView>(R.id.gas)
            val gasList = findViewById<LinearLayout>(R.id.gas_list)
            gas.setOnClickListener {
                if (gasList.visibility == View.GONE) {
                    gasList.visibility = View.VISIBLE
                } else {
                    gasList.visibility = View.GONE
                }
                locationBtn(R.id.medin, mapboxMap, gasMarkers)
                locationBtn(R.id.shamaa, mapboxMap, gasMarkers)
                locationBtn(R.id.hilwah, mapboxMap, gasMarkers)
                locationBtn(R.id.northKedn,  mapboxMap, gasMarkers)
                locationBtn(R.id.southKedn,  mapboxMap, gasMarkers)
                locationBtn(R.id.heran,  mapboxMap, gasMarkers)
                locationBtn(R.id.sherfa,  mapboxMap, gasMarkers)
                locationBtn(R.id.mehakek,  mapboxMap, gasMarkers)
                locationBtn(R.id.shodon,  mapboxMap, gasMarkers)
                locationBtn(R.id.otad,  mapboxMap, gasMarkers)
                locationBtn(R.id.mezalej,  mapboxMap, gasMarkers)
                locationBtn(R.id.osakera,  mapboxMap, gasMarkers)
            }
            //END: Data buttons
        }
    }



    private fun loadJsonFromAsset(filename: String): String {
        return assets.open(filename).bufferedReader().use { it.readText() }
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        }

        val bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)

        return bitmap
    }
}
