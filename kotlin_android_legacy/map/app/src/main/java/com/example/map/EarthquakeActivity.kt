package com.example.map

import android.annotation.SuppressLint
import android.app.Dialog
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
import android.widget.ProgressBar
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
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.Locale
import kotlinx.coroutines.*
import java.text.ParseException
import java.util.Date
import androidx.core.graphics.createBitmap

class EarthquakeActivity : AppCompatActivity(), OnPointAnnotationClickListener {

    data class LocationMarker(
        val latitude: Double,
        val longitude: Double,
        val value: Double,
        val date: java.util.Date,
        val iconResId: Int
    )
    private lateinit var progressBar: ProgressBar

    private lateinit var mapView: MapView
    private lateinit var mapboxMap: MapboxMap
    private lateinit var pointAnnotationManager: PointAnnotationManager
    private val annotationDataMap = HashMap<Long, LocationMarker>()

    //Remove nav bar
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
        setContentView(R.layout.activity_earthquake)
        supportActionBar?.hide()
        progressBar = findViewById(R.id.progressBar)

        //START: Buttons
        val q4to5: Button = findViewById(R.id.q4to5)
        val q5to6: Button = findViewById(R.id.q5to6)
        val q7to6: Button = findViewById(R.id.q7to6)
        val q7: Button = findViewById(R.id.q7)
        val oldEarth: Button = findViewById(R.id.oldEarth)
        //END: Buttons

        //START: Back button
        val homeBtn: FloatingActionButton = findViewById(R.id.home)
        homeBtn.setOnClickListener {
            onBackPressed()
        }
        //END: Back button

        //START: Brief button
        val brief: Button = findViewById(R.id.brief)
        brief.setOnClickListener {
            val popupView = LayoutInflater.from(this).inflate(R.layout.popup_brief, null)
            popupView.findViewById<TextView>(R.id.title).text = "قاعدة البيانات الزلزالية"
            popupView.findViewById<TextView>(R.id.description).text =  "تعتبر الزلازل من الكوارث الطبيعية التي عرفها الإنسان منذ القدم والتي تتسبب عادة في وقوع أعداد كبيرة من الضحايا بالإضافة إلى الخسائر المادية والاقتصادية والاجتماعية الهائلة الناجمة عنها وذلك لأنها تحدث بشكل مفاجئ وسريع وبدون سابق إنذار. الزلازل عبارة عن اهتزازات في القشرة الأرضية تحدث بمشيئة الله ثم بسبب انطلاق وتحرر الطاقة الناتجة عن احتكاك الصخور وتحرك الطبقات الأرضية حول الصدوع الكبيرة، كما تحدث نتيجة لعدة أسباب أخرى منها: الثورات البركانية والاختراق المفاجئ للمواد المنصهرة في باطن الأرض للأجزاء الهشة من القشرة الأرضية، والتفجيرات النووية تحت السطحية وسقوط النيازك كبيرة الحجم على سطح الأرض وانهيارات الكهوف الكبيرة تحت سطح الأرض وإنشاء السدود والبحيرات الصناعية وضح المياه والمخلفات داخل الآبار.\n" +
                    "تقع شبه الجزيرة العربية في نطاق الصفيحة العربية التي تتحرك نحو الشمال الشرقي والتي تحدها خمسة حدود حركية نشطة م : هي: (1) حد زاجروس التقاربي وهو حد زلزالي نشط نتيجة الاصطدام القاري بين الصفيحة العربية وصفيحة إيران بمعدل 2 سم/ السنة تقريبا ونشوء حزام على امتداد الجزء الغربي من إيران وشمال شرق العراق (2) حد البحر الأحمر التباعدي نتيجة انفصال الصفيحة العربية عن الصفيحة الأفريقية، ويزداد هذا الانفصال باتجاه الجنوب ويصل إلى 12 ملم سنويا، ونتيجة لهذا الانفصال تكون ما يسمى بمثلث عفار النشط Triple Junction))  (3)  حد خليج العقبة والبحر الميت التحولي: وهو أيضا حد زلزالي نشط ويقع خليج العقبة في طرفه الجنوبي ويبلغ طوله 1000 كم، وترتبط حركته بحركة اتساع البحر الأحمر وحركة تصادم الصفائح في جنوب تركيا وإيران، ولذا يعرف نظام هذا الحد بنظام التحول النافذ \" Leaky Transform \"، وقد تعرض هذا الحد لمراحل تشوه متعددة خلال حقب زمنية متعاقبة ومتزامنة مع مراحل اتساع البحر الأحمر. بدأت الحركة الجانبية الانزلاقية على حد البحر الميت التحولي منذ ما يقارب 20 مليون عام، حيث أشارت الدراسات الجيوفيزيائية والجيولوجية إلى انزلاق الصفيحة العربية لمسافة تزيد على 105 كم بالمقارنة مع صفيحة سيناء. هذا الصدع يتميز بوجود عدد من المنخفضات المنتشرة على طوله. (4) حد سلسلة جبال مكران - خليج عمان التقاربي (5) حد البحر العربي وخليج عدن التحولي والذي يعتبر من أقل الحدود نشاطا.\n" +
                    "لقد كان الاعتقاد سائداً بأن شبه الجزيرة العربية خالية من أي نشاط زلزالي على مر العصور، ولكن الواقع هو العكس، حيث دلت الدراسات التاريخية والحديثة على أن المنطقة سبق وان تعرضت لبعض الهزات الأرضية والبراكين إن هذا الاعتقاد السائد كان مصدره أولا عدم وجود أجهزة رصد زلزالية في المنطقة علاوة على أن مراكز الهزات في مواقع ذات كثافة سكانية قليلة - والله الحمد - وفي مناطق متباعدة، وهذا بدوره أدى إلى عدم الإحساس بأثرها. على الرغم من قلة النشاط الزلزالي في معظم مناطق المملكة وخاصة الدرع العربي والمسطح العربي إلا أن قربها من المناطق النشطة زلزاليا في إيران وتركيا من ناحية الشمال الشرقي والبحر الأحمر والدرع العربي من جهة الغرب والجنوب الغربي وصدع البحر الميت التحولي شمالا يتطلب دراسة مواقع الزلازل بدقة عالية للاستفادة منها في تحديد مناطق الخطر الزلزالي المحتمل. عموما يتركز النشاط الزلزالي في شبه الجزيرة العربية على امتداد حدود الصفيحة العربية في ثلاث مناطق هي : منطقة خليج العقبة ؛ منطقة جنوب غرب المملكة وجنوب البحر الأحمر واليمن ومنطقة مكة أما وسط شبه الجزيرة العربية وشرقها والدرع العربي فتعتبر اقل المناطق نشاطا.\n" +
                    "قام مركز الدراسات الزلزالية بجامعة الملك سعود عام 1998 م بإصدار أول قاعدة بيانات زلزالية لشبه الجزيرة العربية والدول المجاورة ( SAED ) واشتملت تلك القاعدة على الأحداث الزلزالية التاريخية والحديثة للفترة من  112- 2023 م بمختلف المقادير الزلزالية والواقعة بين خطى طول 30 - 60 درجة شرقاً وخطى عرض 10 - 35 درجة شمالاً. يجري تحديث قواعد البيانات الزلزالية سنويا بما يستجد من الأحداث الزلزالية. وفي هذا الإصدار أيضا يمكن توقيع الزلازل إلى أي فترة زمنية معينة يريدها المستخدم وحسب أي قدر زلزالي معين. كما يمكن اختيار أي موقع جغرافي على الخارطة وتحديد الزلازل التي حدثت فيه حسب الاختيارات المطلوبة. يعتبر هذا الإصدار مرجعاً أساسياً للدراسات والبحوث التي يقوم بإعدادها المختصون في مجال الزلازل والهندسة المدنية للاستفادة منه في تحديث معايير كود البناء السعودي وتحديد مكامن الخطورة الزلزالية على مستوى المملكة بالدقة المطلوبة، ووضع مواصفات قياسية للمباني ومدى مقاومتها لأخطار الزلازل، علاوة على دعم الدراسات الجيولوجية والإنشائية والبيئية للمناطق الآهلة بالسكان والمناطق ذات الأهمية الصناعية والاقتصادية.\n"
            popupView.findViewById<ImageView>(R.id.image).setImageResource(R.drawable.earth)

            val briefDialog = Dialog(this)
            briefDialog.setContentView(popupView)

            val displayMetrics = resources.displayMetrics
            val screenWidth = displayMetrics.widthPixels

            briefDialog.window?.setLayout(
                (screenWidth * 0.8).toInt(), // width of popup
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
        setMapStyle("maps/saudi_geo/sahel.json") // initial map

        pointAnnotationManager = mapView.annotations.createPointAnnotationManager().apply {
            addClickListener(this@EarthquakeActivity)
        }


        // !!! Set initial camera position
        val initialPosition = CameraOptions.Builder()
            .center(Point.fromLngLat(47.189224, 24.694291)) // Riyadh, Saudi Arabia
            .zoom(4.3)
            .build()
        mapboxMap.setCamera(initialPosition)

        val resetZoomBtn: FloatingActionButton = findViewById(R.id.reset_zoom)
        resetZoomBtn.setOnClickListener {
            mapboxMap.setCamera(initialPosition)
        }

        // Define the data with the icons
        q4to5.setOnClickListener {
            setMarkers("4 to 5.xlsx", R.drawable.small)
        }

        q5to6.setOnClickListener {
            setMarkers("5 to 6.xlsx", R.drawable.medium)
        }

        q7to6.setOnClickListener {
            setMarkers("6 to 7.xlsx", R.drawable.larg)
        }

        q7.setOnClickListener {
            setMarkers("7 and above.xlsx", R.drawable.extra_larg)
        }

        oldEarth.setOnClickListener {
            setMarkers("Histroical.xlsx", R.drawable.square)
        }

    }

    private fun setMarkers(excelFileName: String, iconResId: Int) {
        progressBar.visibility = View.VISIBLE  // Show the ProgressBar

        CoroutineScope(Dispatchers.IO).launch {
            val markers = readLocationMarkersFromExcel(excelFileName, iconResId)
            withContext(Dispatchers.Main) {
                pointAnnotationManager.deleteAll()
                markers.forEach { addMarkerWithPopup(it) }
                progressBar.visibility = View.GONE  // Hide the ProgressBar
            }
        }
    }

    private fun addMarkerWithPopup(marker: LocationMarker) {
        val point = Point.fromLngLat(marker.longitude, marker.latitude)
        val iconId = resources.getResourceEntryName(marker.iconResId)
        val pointAnnotationOptions = PointAnnotationOptions()
            .withPoint(point)
            .withIconImage(iconId)
            .withIconSize(0.2) // Adjust size as needed

        val annotation = pointAnnotationManager.create(pointAnnotationOptions)
        annotationDataMap[annotation.id] = marker

    }

    @SuppressLint("DiscouragedApi", "SimpleDateFormat")
    private fun readLocationMarkersFromExcel(fileName: String, iconResId: Int): List<LocationMarker> {
        val markers = mutableListOf<LocationMarker>()
        try {
            val inputStream = assets.open("earthquake/$fileName")
            val workbook = XSSFWorkbook(inputStream)
            val sheet = workbook.getSheetAt(0)
            val dateFormat = SimpleDateFormat("dd/MM/yyyy HH:mm:ss") // Set your date format here

            for (row in sheet) {
                if (row.rowNum == 0) continue

                if(fileName !== "Histroical.xlsx") {
                    val date = row.getCell(0).dateCellValue
                    val latitude = row.getCell(1).numericCellValue
                    val longitude = row.getCell(2).numericCellValue
                    val value = row.getCell(3).numericCellValue
                    markers.add(LocationMarker(latitude, longitude, value, date, iconResId))
                }else{
                    val dateString = row.getCell(0).stringCellValue
                    val date: Date? = try {
                        dateFormat.parse(dateString)
                    } catch (e: ParseException) {
                        null
                    }
                    if (date == null) continue
                    val latitude = row.getCell(1).numericCellValue
                    val longitude = row.getCell(2).numericCellValue
                    val value = row.getCell(3).numericCellValue
                    markers.add(LocationMarker(latitude, longitude, value, date, iconResId))

                }
            }
            workbook.close()

        } catch (e: IOException) {
        }

        return markers
    }


    override fun onAnnotationClick(annotation: PointAnnotation): Boolean {
        val markerData = annotationDataMap[annotation.id] // Retrieve data from the map
        if (markerData != null) {
            showPopup(markerData.value, markerData.date)
        }
        return true
    }

    private fun setMapStyle(assetPath: String) {
        val styleJson = loadJsonFromAsset(assetPath)
        mapboxMap.loadStyleJson(styleJson) { style ->

            // Define icon resources
            val iconResources = listOf(R.drawable.small, R.drawable.medium,  R.drawable.larg, R.drawable.extra_larg, R.drawable.square)

            // Add each icon to the style
            iconResources.forEach { iconResId ->
                val iconDrawable = ContextCompat.getDrawable(this, iconResId)
                iconDrawable?.let {
                    val iconBitmap = drawableToBitmap(it)
                    val iconId = resources.getResourceEntryName(iconResId)
                    style.addImage(iconId, iconBitmap)
                }
            }

        }
    }

    // The pop when you click on earth quake
    @SuppressLint("InflateParams", "SetTextI18n")
    private fun showPopup(value: Double, date: java.util.Date) {
        val dateFormat = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
        val timeFormat = SimpleDateFormat(" HH:mm:ss", Locale.getDefault())

        val formattedDate = dateFormat.format(date)
        val formattedTime = timeFormat.format(date)

        val popupView = LayoutInflater.from(this).inflate(R.layout.popup_layout, null)
        popupView.findViewById<TextView>(R.id.description).text =
            "قدر الزلزال (Magnitude) : " + value + "\n" + "التاريخ: " + formattedDate + "\n" + "الوقت: " + formattedTime  + "(GMT)"

        val dialog = Dialog(this)
        dialog.setContentView(popupView)

        val displayMetrics = resources.displayMetrics
        val screenWidth = displayMetrics.widthPixels

        dialog.window?.setLayout((screenWidth * 0.3).toInt(), LinearLayout.LayoutParams.WRAP_CONTENT)
        dialog.show()

        val closeButton = popupView.findViewById<Button>(R.id.closeButton)
        closeButton.setOnClickListener {
            dialog.dismiss()
        }
    }


    private fun loadJsonFromAsset(filename: String): String {
        return assets.open(filename).bufferedReader().use { it.readText() }
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        }

        val bitmap = createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)

        return bitmap
    }
}
