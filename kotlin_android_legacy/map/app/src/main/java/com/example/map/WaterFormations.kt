package com.example.map

import android.annotation.SuppressLint
import android.app.Dialog
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.CameraOptions
import com.mapbox.geojson.Point
import android.widget.ProgressBar
import android.os.Build
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.PopupWindow
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.mapbox.geojson.Feature
import com.mapbox.geojson.FeatureCollection
import com.mapbox.maps.extension.style.layers.addLayer
import com.mapbox.maps.extension.style.layers.generated.LineLayer
import com.mapbox.maps.extension.style.layers.getLayer
import com.mapbox.maps.extension.style.layers.properties.generated.LineCap
import com.mapbox.maps.extension.style.layers.properties.generated.LineJoin
import com.mapbox.maps.extension.style.sources.addSource
import com.mapbox.maps.extension.style.sources.generated.geoJsonSource
import com.mapbox.maps.extension.style.layers.properties.generated.Visibility
import com.mapbox.maps.extension.style.layers.getLayerAs
import com.mapbox.maps.RenderedQueryOptions
import com.mapbox.maps.extension.style.sources.getSource
import com.mapbox.maps.plugin.annotation.generated.OnPointAnnotationClickListener
import com.mapbox.maps.plugin.annotation.generated.PointAnnotation
import com.mapbox.maps.plugin.gestures.addOnMapClickListener
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.IOException
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Date
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions
import com.mapbox.maps.plugin.annotation.annotations
import kotlinx.coroutines.*
import com.mapbox.maps.plugin.annotation.generated.createPointAnnotationManager



class WaterFormations : AppCompatActivity() , OnPointAnnotationClickListener {

    private lateinit var mapView: MapView
    private lateinit var mapboxMap: MapboxMap
    private lateinit var progressBar: ProgressBar
    private var isValleyStyleLoaded = false
    private var lastClickTime = 0L
    private val valleyNamesMap = mutableMapOf<String, String>()
    private lateinit var pointAnnotationManager: PointAnnotationManager
    private val annotationDataMap = HashMap<Long, LocationMarker>()
    private val damAnnotations = mutableMapOf<String, PointAnnotation>()
    private var damButtonsCreated = false

    private val valleysList = mapOf(

        "Wadi_Aba_Al_Qu" to Pair("maps/valleys/Wadi_Aba_Al_Qu.geojson", "#1aa33f"),
        "Wadi_Aba_Ar_Ruwath" to Pair("maps/valleys/Wadi_Aba_Ar_Ruwath.geojson", "#a31f1a"),
        "Wadi_Al_Ahsabah" to Pair("maps/valleys/Wadi_Al_Ahsabah.geojson", "#a3411a"),
        "Wadi_Al_Akhda" to Pair("maps/valleys/Wadi_Al_Akhda.geojson", "#73a31a"),
        "Wadi_Al_Amq" to Pair("maps/valleys/Wadi_Al_Amq.geojson", "#3ca31a"),
        "Wadi_Al_Batin" to Pair("maps/valleys/Wadi_Al_Batin.geojson", "#1aa333"),
        "Wadi_Al_Farshah" to Pair("maps/valleys/Wadi_Al_Farshah.geojson", "#1aa333"),
        "Wadi_Al_Gharr" to Pair("maps/valleys/Wadi_Al_Gharr.geojson", "#1aa375"),
        "Wadi_al_Ghinah" to Pair("maps/valleys/Wadi_al_Ghinah.geojson", "#1aa375"),
        "Wadi_Al_Hamal" to Pair("maps/valleys/Wadi_Al_Hamal.geojson", "#1a93a3"),
        "Wadi_Al_Hamd" to Pair("maps/valleys/Wadi_Al_Hamd.geojson", "#1a75a3"),
        "Wadi_Al_Hinu" to Pair("maps/valleys/Wadi_Al_Hinu.geojson", "#1a45a3"),
        "Wadi_Al_Jarir" to Pair("maps/valleys/Wadi_Al_Jarir.geojson", "#251aa3"),
        "Wadi_Al_Jizil" to Pair("maps/valleys/Wadi_Al_Jizil.geojson", "#5c30c2"),
        "Wadi_al_Judwal" to Pair("maps/valleys/Wadi_al_Judwal.geojson", "#641ca3"),
        "Wadi_Al_Khurmah" to Pair("maps/valleys/Wadi_Al_Khurmah.geojson", "#7d1ca3"),
        "Wadi_Al_Lith" to Pair("maps/valleys/Wadi_Al_Lith.geojson", "#a31c9c"),
        "Wadi_Al_Makhit" to Pair("maps/valleys/Wadi_Al_Makhit.geojson", "#a31c7b"),
        "Wadi_Al_Maqran" to Pair("maps/valleys/Wadi_Al_Maqran.geojson", "#a31c5f"),
        "Wadi_Al_Mira" to Pair("maps/valleys/Wadi_Al_Mira.geojson", "#a31c40"),
        "Wadi_al_Qimra" to Pair("maps/valleys/Wadi_al_Qimra.geojson", "#a31c29"),
        "Wadi_Ar_Raka" to Pair("maps/valleys/Wadi_Ar_Raka.geojson", "#7d803b"),
        "Wadi_Ar_Risha" to Pair("maps/valleys/Wadi_Ar_Risha.geojson", "#61803b"),
        "Wadi_Ar_Rumah" to Pair("maps/valleys/Wadi_Ar_Rumah.geojson", "#42803b"),
        "Wadi_Arar" to Pair("maps/valleys/Wadi_Arar.geojson", "#3b8050"),
        "Wadi_As_Sahba" to Pair("maps/valleys/Wadi_As_Sahba.geojson", "#3b8063"),
        "Wadi_As_surrah" to Pair("maps/valleys/Wadi_As_surrah.geojson", "#3b7b80"),
        "Wadi_Ash_Shu-bah" to Pair("maps/valleys/Wadi_Ash_Shu-bah.geojson", "#3b6b80"),
        "Wadi_Baysh" to Pair("maps/valleys/Wadi_Baysh.geojson", "#3b5480"),
        "Wadi_Bishah" to Pair("maps/valleys/Wadi_Bishah.geojson", "#3b3c80"),
        "Wadi_Bitat" to Pair("maps/valleys/Wadi_Bitat.geojson", "#513b80"),
        "Wadi_Damad" to Pair("maps/valleys/Wadi_Damad.geojson", "#673b80"),
        "Wadi_Dawqah" to Pair("maps/valleys/Wadi_Dawqah.geojson", "#7e3b80"),
        "Wadi_Fajr" to Pair("maps/valleys/Wadi_Fajr.geojson", "#803b69"),
        "Wadi_Hali" to Pair("maps/valleys/Wadi_Hali.geojson", "#803b4f"),
        "Wadi_Hamir" to Pair("maps/valleys/Wadi_Hamir.geojson", "#db6353"),
        "Wadi_Hanifah" to Pair("maps/valleys/Wadi_Hanifah.geojson", "#9adb53"),
        "Wadi_Hirjab" to Pair("maps/valleys/Wadi_Hirjab.geojson", "#63db53"),
        "Wadi_Hubuna" to Pair("maps/valleys/Wadi_Hubuna.geojson", "#53db85"),
        "Wadi_Itwad" to Pair("maps/valleys/Wadi_Itwad.geojson", "#53dbc9"),
        "Wadi_Najran" to Pair("maps/valleys/Wadi_Najran.geojson", "#539adb"),
        "Wadi_Nayyal" to Pair("maps/valleys/Wadi_Nayyal.geojson", "#6a53db"),
        "Wadi_Qatan" to Pair("maps/valleys/Wadi_Qatan.geojson", "#9a53db"),
        "Wadi_Ranyah" to Pair("maps/valleys/Wadi_Ranyah.geojson", "#cb53db"),
        "Wadi_Rash" to Pair("maps/valleys/Wadi_Rash.geojson", "#db53bc"),
        "Wadi_Shuwayhat" to Pair("maps/valleys/Wadi_Shuwayhat.geojson", "#db538e"),
        "Wadi_Tabalah" to Pair("maps/valleys/Wadi_Tabalah.geojson", "#db5353"),
        "Wadi_Tarif" to Pair("maps/valleys/Wadi_Tarif.geojson", "#197d05"),
        "Wadi_Tarj" to Pair("maps/valleys/Wadi_Tarj.geojson", "#057d6f"),
        "Wadi_Tathlith" to Pair("maps/valleys/Wadi_Tathlith.geojson", "#05337d"),
        "Wadi_Turubah" to Pair("maps/valleys/Wadi_Turubah.geojson", "#35057d"),
        "Wadi_Yabah" to Pair("maps/valleys/Wadi_Yabah.geojson", "#7d054b")
    )
    private val polygonInfo = hashMapOf(
        "Jauf_Formation-3102c9" to Pair(
            "تكوين الجوف",
            "يتبع عصر الديفوني السفلى وتتكون طبقاته من صخور الطفل الغريني وحجر الرمل وحجر الجير والدلوميت. ويقع فوق متكون تبوك. وينكشف شمال شرق النفود ويمتد حتى الأردن. ويبلغ طول المنكشف 100 كم، ويحتفظ هذا التكوين بكميات متوسطة من الماء. يستغل المتكون في منطقة الجوف، ويبلغ معامل النقولية له 95 م /يوم، وملوحة مياهه 1200 ملجم/لتر. تغلب الصخور الرملية ذات الحبيبات الناعمة والمتوسطة على محتويات تكوين الجوف ويبلغ سمكه في المنطقة بين سكاكا وعرعر 431 متر إلا أن سمكه يصل في سكاكا إلى 700 متر وتتراوح إنتاجيته من المياه بين 16 – 24 لتر / ثانية كما تختلف الناقلية في الخزان حيث تتراوح بين 0.0011 و 0.002 م/ ثانية ويصل تركيز الأملاح في مياهه بالجوف إلى 700 ملجم/لتر."
        ),
        "Aruma_Formation-4kp806" to Pair(
            "تكوين العرمه",
            "يتبع هذا التكوين العصر الكريتاوي العلوي ويوجد تحت تكوين أم رضه وفوق الوسيع. ينكشف لمسافة 1600 كم من وادي الدواسر جنوباً حتى الحدود العراقية، ويتكون من الدلوميت والطفل مع بعض حجر الرمل ويصل سمكه إلى 142 م. ويعتبر من التكاوين الجيدة وهو على اتصال بتكوين أم رضمه ولكنه أقل أهمية منه. مياه العرمة جيدة وتستغل في منطقة حفر الباطن وفي أجزاء من المنطقة الشرقية وفي رفحة وبدنه وتتراوح ملوحة مياهه بين 850 – 2100 ملجم / لتر."
        ),
        "Neogene_Formation-98k03q" to Pair(
            "تكوين النيوجين",
            "ينتشر هذا التكوين في شرق المملكة بدءاً من وادي الدواسر جنوباً إلى وادي السرحان شمالاً , وهو يمتد ايضا تحت رمال الربع الخالي , ويتكون هذا التكوين من رسوبيات العصر الرباعي من الحجر الجيري وهو ذو اصل بحري ، وتعتمد الزراعة في وادي المياه ومنطقة الإحساء بشكل رئيس على هذا التكوين حيث تستمد معظم العيون الموجودة هناك مياهها منه. ينقسم التكوين إلى أربع طبقات وهي :متكون الهدروخ ويتكون من الطفل الطيني الأخضر وحجر الرمل الغريني الجيري والمارل الرمادي وبعض الجبس وحجر الجير الرملي، وهو يرتكز دون توافق على متكون الدمام ويبلغ سمكه حوال 85 كم، وعمره يتبع المبوسين المبكر. متكون الدام ويتكون من حجر الجير الرملي والمارل والطفل وقليل من حجر الرمل، ويعلو متكون الهدروخ وسمكه حوالي 90 م ويتبع عصر الميوسين الأوسط .متكون الهفوف ويتركب من حجر رملي ومارل رملي وحجر جيري رملي وكونجلوميرات ويصل سمكه إلى 95 م ويعلو متكون الدام، ويتبع عصر الميوسين المتأخر والبليوسين. متكون الخرج ويتركب من حجر الجير والجبس وطبقات من الكونجلوميرات والحصى والرمل الجبسي، ويصل سمكه إلى 28 م ويتبع عصر البليوسين. يزيد سمك هذه المتكونات عن 250 م في المنطقة الشرقية ويقل كلما اتجهنا إلى الغرب. ويعد تكوين النيوجين من التكوينات الهامة في منطقة الهفوف إذ يختزن كميات من كبيرة من المياه ومعظم مياه العيون والآبار في الإحساء تأتي من متكون النيوجين. تحوي هذه المكامن بين طبقاتها الكثير من أسطح التـعرية التي زادت من مساميتها ونفاذيتها الثانويتين فأصبحت تشكل أهم الخزانات المائيـة في منطقـة الأحساء حيث تتدفق العيون وتكثر الآبار. والخزان المائي في صخور هـذه المجموعـة هو في غالبيتـه خزان غير حبـيس، وإن كانت المياه تُحبَس في بعض أجزائه حبساً موضعياً نظراً لوجود بعض الراقات غير المنفذة بين تتـابع طبقاتـه. وتختلف نـوعيـة مياه خزانات صخور النيوجين من مكان إلى آخر باختلاف تركيب الصخور التي تحتويها، ويتراوح مجموع الأملاح المذابـة فيها بين 1000 و 4000 ملليجرام / لتر. وتقدر كمية التغذية بحوالي 328 مليون متر مكعب سنوياً."
        ),
        "Dammam_Formation-8o2pjs" to Pair(
            "تكوين الدمام",
            "يمتد تكوين الدمام في مناطق متفرقة حول ساحل الخليج العربي , و يتكون من خمسة طبقات ( صخور ذات اصل بحري ) , غير ان هناك طبقتين فقط حاملتين للمياه وهما طبقة العلاة وطبقة الخبر , تتكون طبقة العلاة من الحجر الجيري الدلوميتي المسامي وفي أسفله طبقة مارل بينما تتكون طبقة الخبر من الحجر الجيري والحجر الجيري المارلي ، وتسفله طبقة مارل، وقد تعرضت الطبقتان لعوامل تعرية كيميائية ونتج منها شقوق وفجوات في كلتا الطبقتين مما أدى إلى زيادة نفاذيتها، وهناك اتصال مائي طبيعي بين الطبقتين وصناعي ناتج عن حفر الآبار خلال الطبقتين دون حجب إحداهما عن الأخرى ، ويتراوح سمك تكوين الدمام من 50 الى 75 متر  ويعتبر من أهم التكوينات المائية اقتصادياً نظراً لقلة عمقه وسهولة الحفر فيه ونوعية مياهه، وتستفيد منه الخبر والدمام والقطيف والهفوف. يظهر هذا المتكون في شرق المملكة ويرجـع إلى عصر الإيوسين المتوسط ويتكون أساساً من الحجر الجيري مع بعض راقات من الصلصال الكلسي والصفحي. ويعتبر متكون الدمام المكمن المائي الرئيس لشرقي الجزيرة العربية، وتظهر صخوره في حزام غير متصل يبلغ طوله حوالي 180 كيلومتراً، وعرضـه من حوالي خمسة كيلومترات إلى مائتي كيلومتر (من وادي السهباء في الجنوب إلى الحدود الشمالية للمملكة حيث يصل عرض الحزام إلى حوالى 200 كيلومتر). وتظهر صخور المتكون حول قبة الدمام بسمك يبلغ 30 متراً تقريباً حيث ينتهي بكسر هائل في تـتابـع الطبقات أدى إلى تعرض صخور ذلك المتكون للمزيد من أعمال التعريـة التي أكسبت ما تبقى من صخوره نفاذيـة ومساميـة ثانويـتـين، بالإضافـة إلى العديد من حفر الإذابـة التي زادت من قدرة تلك الصخور الجيريـة على خزن مياه الأمطار. مياه متكون الدمام غزيرة وهي مياه متوسطـة النوعيـة حيث تقل الأملاح الذائبـة فيها عن 2000 ملليجرام / لتر، إلا أن ملوحتها تزداد كلما اتجهنا شرقاً أو جـنـوباً حتى تصل إلى أكثر من 6000 ملليجرام / لتر في المناطق الساحلية بسبـب تداخل مياه الخليج العربي في صخور ذلك المكمن. ويقدر عمر المياه في متكون الدمام بنحو 25 ألف سنـة ويتراوح سمك التكوين من 50 إلى 75 متراً. ويبلغ معدل التغذية السـنوية من مياه الأمطار 1601 مليون متر مكعب. ويستغل تكوين الدمام في المنطقة الشرقية والبحرين لأعراض الشرب الزراعية وتتراوح نوعية مياه التكوين من متوسطة إلى رديئة، وتسوء نوعيتها كما اتجهنا شرقاً أو جنوباً، ففي الغرب تبلغ 1000 ملجم/لتر، بينما في المناطق الساحلية تصل 6000 ملجم/لتر، وقدرت كمية المخزون في الأجزاء غير المحصورة بحوالي 5000 مليون متر مكعب بينما قدرات التغذية السنوية بحوالي 200 مليون متر مكعب."
        ),
        "Umm_er_radhuma_Formation-31a0hp" to Pair(
            "تكوين أم الرضمة",
            " يمتد من الحدود العراقية والاردنية في الشمال الى جنوب وادي الدواسر لمسافة 1200 كم ، ويتكون من الحجر الحبيبي الطباشيري والدولومايت وبعض الطفل الذي ينتمي الى الاصل الحجري , ويتفاوت سمك التكوين بشكل عام من الغرب الى الشرق ومن الشمال الى الجنوب , وتختلف نوعية مياهه تبعاً لبعده عن المناطق الساحلية. وتستفيد منه الظهران وشدقم والخبر والدمام وحرض وبعض المناطق في الإحساء ووادي المياه.  يتبع متكون أم رضمة عصري الباليوسين المتأخر / الإيوسين المبكر ويتكون أساساً من صخور جيريـة تتحول بدورها إلى صخور رملية في الأجزاء الجنوبية الغربية من أرض المملكة. ويمتد ظاهر متكون أم رضمة في حزام يبلغ طوله 1200 كيلومتر، ويتراوح عرضه بين  60 و  120 كيلومتراً (من وادي الدواسر جنوباً إلى الحدود الشمالية للمملكة)، ثم يظهر مرة أخرى بتركيب صخري مغاير قليلاً في حوض وادي السرحان (حوض سكاكا- تبوك) من غرب عرعر إلى الحدود السعوديـة- الأردنيـة، ويمتد جنوباً من تلك الحدود إلى منطقـة الطبيق. ويبلغ متوسط سمك متكون أم رضمة في قطاعاتـه الظاهرة فوق سطح الأرض حوالي 250 متراً، ويزداد ذلك إلى حوالي 700 متر تحت سطح المنطقة الشرقية. والمتكون ملئ بحفر الإذابـة التي مكنتـه من تخزين كميات من مياه الأمطار على الرغم من قلة مسامية ونفاذيـة صخوره بصفة عامـة. ونوعـية المياه في متكون أم رضمـة جيدة بالقرب من طبقاته حيث يبلغ مجموع الأملاح الذائبـة بها حوالي 1000 ملليجرام / لتر، إلا أن ذلك يزداد شرقاً وشمالاً ليصل إلى 4000 ملليجرام / لتر. وتتدهور خصائص مياهـه في المناطق الساحلية تدهـوراً ملحوظاً وذلك نظراً لتسرب بعض مياه الخليج إليه مع وجود ألسنـة من المياه قليلة الملوحـة. وتقدر كمية مياه الأمطار التي تغذي هذا المكمن بنحو 2405 أمتار مكعبة سـنوياً. يعتبر تكوين أم الرضمة من أهم الخزانات الجوفية العذبة في المملكة حيث أن حجر الجير النقي ذو خصائص هيدروليكية لا مثيل لها في غيرها من التكاوين المائية فمساميته عالية ونفاذيته جيدة جدا إضافة ألي وجود العديد من الشقوق والكهوف اتحت سطحية التي تكونت بسبب إذابة الصخور الجيرية. يميل تكوين أم رضمه الي الانسياب الارتوازي التلقائي على طول ساحل الخليج العربي وفي المناطق المنخفضة. تؤثر عوامل عديدة على نوعية مياه أم رضمة منها نوعية مياه التغذية المتسربة والمعادن القابلة للذوبان في الصخور اضافة الى الى تداخل مياه البحر في المناطق الساحلية . ويبلغ متوسط مجموع الأملاح الذائبة حوالي 1000 ملجم/ لتر في المنكشف إلا أنها تسوء في المنطقة الساحلية لتصل إلى اكثر من 4000 ملجم/لتر. قدرت كمية اتغذية بحوالي 2406 مليون متر مكعب  بعضها من مياه الأمطار والسيول والباقي يأتي من تسرب الخزانات الجوفية."
        ),
        "Wasia_Formation-8gn6np" to Pair(
            "تكوين الوسيع",
            "تتألف صخور تكوين الوسيع ، من صخور رملية رقيقة نسبيا ، وطفل وعدسات من الكربونات . ويمتد منكشف الوسيع حوالي 1450 كم من الربع الخالي في اتجاه الشمال على شكل قوس ضخم يمر تحت الطرف الغربي من النفود الكبير . يوجد منكشف الوسيع في شكل مقطع كامل في خشم الوسيع الواقع شمال وادي السهبا ، يمتد منكشف الوسيع مسافة 1460 كم على شكل شريط هلالي من شمال وادي الدواسر حتى النفوذ الكبير بالشمال حيث يختفى تحت كثبانه ثم يظهر على سطح الارض ثانية وينكشف بالقرب من سكاكا حيث يعرف بحجر رمل سكاكا، ويعلوه احجار جيرية تابعة لتكوين العرمة. يشكل متكونا البياض والوسيع وحدة مائية واحدة ويعتبر من خرانات المياة الجوفية الممتازة في المملكة . متكون الوسيع قاري الاصل ترسب في العصر الطباشيري الاوسط ويتكون من حبيبات رملية غير متماسكه متوسطة الى خشنة. يتراوح سمك التكوين بين 200 و230 م  ويزداد سمكه تجاه الشمال حتى يبلغ 285 م بالقرب من سكاكا.  ويبلغ اقصى سمك له في الجنوب 600 م تحت الربع الخالي. يغذى المتكون مع متكون البياض منطقة الرياض و حفر.الباطن وقدر مجموع ما يستخرج من هذه التكوين بواقع 75 مليون متر مكعب. يقدر حجم المخزون في تكون الوسيع تقريبا حوالي 57000 مليون متر مكعب. قدرت كمية التغذية السنوية للتكوين من مياه الامطار والسيول حوالي 419 مليون متر مكعب. تغذي طبقة الوسيع - البياض جبال طويق , ويقدر عمر الماء عند المنكشف بالقرب من خريص بنحو 16 الف سنة ويرجع متكونا البياض والوسيع إلى العصر الطباشيري المبكر والمتوسط،. وعلى الرغم من ذلك فإن كلا المتكونين يغلب عليهما الصخور الرملية عالية المسامية والنفاذيـة، التي يمتد ظاهرها لمسافات كبيرة تتعدى الألف كيلومتر في الطول وعشرات الكيلومترات في العرض، ولذا فكلاهما مشبع بالمياه، وغالباً ما يتصل الخزانان ليكونا مكمناً مائياً واحداً يعرف بـاسم مكمن البياض - الوسيع، الذي يعتبر من أوفر مكامن المياه بالمملكة، وتتراوح نسبـة الأملاح في مياه هذا المكمن المائي بين 550 و 6000 ملليجرام / لتر. ويقدر عمر المياه عند المنكشف بالقرب من خريص بنحو 16 ألف سنـة."
        ),
        "Biyadh_Formation-ciunt8" to Pair(
            "تكوين البياض",
            "يمتد تكوين البياض على شكل شريط هلالي من وادي الدواسر جنوبا حتى وادي العتش شمالا لمسافة 650 كلم ويبلغ عرض منكشفة 50 كلم في وادي الدواسر. وتوجد اجزاءه المحصورة المغطاه بمختلف الرسوبيات في المنطقة الشرقية والشمالية الشرقيه والربع الخالي وتمتد داخل حدود قطر والكويت والعراق، ومعظم اجزائه المحصورة مغطاه بالاحجار الرمليه لتكوين الوسيع وفي معظم المناطق خاصة في المنكشفات لا يمكن الفصل بين البياض والوسيع حيث يكونان وحدة مائية واحدة، يحد البياض من الأسفل تكوين البويب المكون من الاحجار الجيرية مع الاحجار الرملية والطفل. تكوين البياض قاري الاصل من العصر الطباشيري الاسفل ويتكون اساسا من حبيبات الرمل والاحجار الرملية مع طبقات رقيقة من الطفل والمارل والدلومايت والحجر الحديدي وتتغير السحنة في اتجاه الشرق من احجار رملية الى رمليه طفلية الى احجار جيريه. يبلغ اقصى سمك للمتكون 625 متر ويقل سمكة كلما اتجهنا شمالا. نوعية الياه في المتكون مالحة الى شديدة الملوحة وتبلغ كمية الاملاح الذائبة قرب المنكشف حوالي 1500 ملجم/لتر بينما تصل الى اكثر من 6000 ملجم/لتر في المنطقة الشرقية، اما في منطقه الخرج فان المياه ذ ات نوعيه جيده وتبلغ الاملاح الذائبه حوالي 550 -900 ملجم / لتر. يستغل تكوين البياض في مناطق الخرج ووادي السهبا ووادي نساح وخريص."
        ),
        "Minjur_Formation-cp2j29" to Pair(
            "تكوين المنجور",
            "يقع تكوين المنجور وسط المملكة والى الشرق من تكوين الساق وتبلغ مساحتة نحو 6500 كيلومتر مربع , وهو يتكون من الاحجار الرملية ذات الاصل القاري المتعددة الطبقات وتوجد عليها طبقات رقيقة من الصخور الجيرية والطفل والجبس . وهو يعتبر من التكوينات العميقة نسبياً حيث يوجد على أعماق تصل لأكثر من 1800م،  وتستفيد منه منطقة الرياض وسدير والوشم والخرج والأفلاج والسليل. يرجع متكون المنجور في العمر إلى الترياسي المتأخر / الجوراسي المبكر ويتكون من الرمل الخشن عالي المسامية والنفاذيـة، ولذلك فهو مشبع بالمياه. وقد درست عينات من مياهه من بئر الشميسي في الرياض فوجد أن عمرها يرجع إلى ما بين 35 و 40 ألف سنـة، بينما يرجـع عمر متكون ضرما إلى الجوراسي المتوسط ويغلب على تركيبـه الطفل والطفل الكلسي والحجر الجيري، وتتحول تلك الصخور في الجزء الجنوبي من المملكة إلى صخور رملية مما يسمح بتشبعها بالمياه فتشكل مع متكون المنجور- الذي تعلوه بصورة لا توافقية- خزاناً مائياً واحداً يطلق عليه مكمن المنجور / ضرما وذلك جـنوب خط عـرض °20 شمالاً، وتتراوح نسبـة الأمـلاح في مياه ذلك الخزان المائي بين 400 و 1500 ملليجرام / لتر. وتزداد الملوحـة باتجاه الشرق وكذلك مع زيادة العمق. وتبلغ مساحة منكشف المنجور حوالي 2500 كيلومتر مربع كما تصل سماكـة التكوين إلى 400 متر تشمل طبقتين حاملتين للمياه تحت السطحيـة. يعتبر المنجور واحد من الخزانات الجوفية المهمة ذات المياه الغزيرة في المملكة حيث تخترقه الكثير جدا من الابار في منطقة الرياض وما حولها وهو ذو مسامية ونفاذية عالية جدا. وتختلف خصائصه الهيدروليكية بدرجة كبيرة من مكان لاخر يتغذى المنجور بواسطة هطول الامطار على منكشفه وقدرت كمية التغذية بحوالي 85 مليون متر مكعب سنويا على امتداد منكشفه."
        ),
        "Wajid_Formation-0m41k3" to Pair(
            "تكوين الوجيد",
            "يوجد في جنوب ووسط المملكة، وتستفيد منه منطقة وادي الدواسر.  يمتد مابين وادي نجران وشرورة في الجنوب و وادي الدواسر في الشمال لمسافة 300 كم ولا يزيد عرضة عن 100 كم , ويتكون من الاحجار الرملية ذات الحبيبات الخشنة والناعمة ترجع إلى حقب الحياة القديمة ’ كما تقع الصخور الرملية لتكوين الوجيد على الصخور النارية والمتحولة ويتراوح سمك تكوين الوجيد من 200 إلى 900 متر . تغطي صخوره مساحـة في جنوب غربي المملكة تقدر بحوالي عشرين ألف كيلو متر مربع، بسمك متوسط في حدود 400 متر، وإن كان ذلك السمك يزداد تدريجيا كلما اتجهنا شرقاً ليصل إلى قرابـة الألف متر. وتتراوح أعماق مياهه من 100 إلى 1100 متر كما يقدر عمر مياهه بحوالي 300 ألف سنـة أو أكثر. وتقل الملوحـة في مياه تكوين الوجيد عن 1000 ملليجرام / لتر، وقدرت كمية مياه الأمطار التي تغذي المتكون بنحو 500 مليون متر مكعب سنوياً. وتستغل مياه الوجيد في وادي الدواسـر منذ 1966م حيث تندفن صخوره تحت متكونات أحدث عمراً بين وادي الدواسـر ووادي نجران، وتندفع شرقاً تحت الأجزاء الغربيـة من الربع الخالي إلى مسافـة كبيرة محتفظـة بتركيبها الرملي، مما يزيد في إمكانيـة تلك المكامن المائـية التي تشبـه مياهها في خواصها الكيميائية والطبيـعية مياه مكمن متكون ساق."
        ),
        "Tabuk_Formation-767mbq" to Pair(
            "تكوين تبوك",
            "يمتد تكوين تبوك جنوب وشرق الحدود الاردنية والى وادي الرمة جنوبا , حيث تبلغ مساحتة 100 الف كيلومتر مربع , كما ينفصل التكوين عن بعضة البعض بالحزام الرملي لصحراء النفوذ الكبرى , هذا ويظهر تكوين تبوك الى الغرب من النفوذ الكبير في ثلاث مناطق وهي تبوك والطويل والجوف , وتستفيد منه المناطق السابقة في تكوين الساق عدا منطقة السر. تـرجع مجموعـة تبوك إلى العصرين الأوردو فيشي المتوسط / السيلوري ، وتـتكون المجمـوعـة من ثلاث وحدات من الصخور الرملية المتبادلـة مع ثلاث وحدات من الصخور الطفلية. ويـبلغ متوسط سمك الوحدات الرملية الحاملـة للمياه في هذه المجموعـة حوالي 200 متر وإن كان سمك المجمـوعـة يتجاوز الألف متر في بعض الأماكن. ويغطي الجزء المنكشف منها مساحة تقدر بأكثر من مائة ألف كيلو متر مربع ، ومياه تلك المجموعـة جيدة إذ تتراوح ملوحتها بين 400 إلى 600 ملليجرام / لتر في المتوسـط وتزداد الملوحـة في الاتجاه الجنوبي، وتعتمد مناطق تبوك والقصيم على مياه تلك المكامن بالإضافـة إلى مياه مكمن متكون ساق. ويختلف سمك تكوين تبوك من منطقة لاخرى تبعا لوجود جميع اجزائه او بعضا منها، ويبلغ سمكة 1070 م ويوجد منكشفه في مناطق تبوك وتيماء وحائل والقصيم ويعتبر من أغنى التكوينات الحاملة للماء بالمملكة . ويبلغ عمر المياه في متكون تبوك اكثر من ثلاثين الف سنة وتم تقدير المخزون بحوالي 1300 مليون متر مكعب."
        ),
        "Saq_Formation-657oal" to Pair(
            "تكوين الساق",
            "يمتد من شمال غرب المملكة ( الحدود الأردنية ) حتى نفوذ السر جنوبا , ويبلغ امتدادة 1200 كيلومتر , وهو يتكون من الأحجار الرملية التي تعو إلى العصر الكمبري , ويقدر عمر مياة الساق بين 22 الف إلى 28 الف سنة ,ويتراوح عمق المياه في تكوين الساق بين 100م في منطقة الجنوب إلى 1850م في القصيم.\n" +
                    "،ويستفيد من الجزء الشرقي من التكوين منطقة القصيم مثل بريدة وعنيزة ومنطقة السر والأسياح وشرق حائل ومنطقة تبوك وتيماء. يعتبر أهم مكامن المياه في المملكة على الإطلاق، وذلك لأن متكون ساق يعلو صخور الدرع العربي المصمتة مباشرة بسمك متوسط يزيد على خمسمائة متر، ويغلب على تركيـبه الصخور الرملية عالية المسامية و النفاذية، وإن تخللتها في أجزائها العليا بعض راقات من الطفل (الصلصال الصحفي). ويتبع متكون ساق في عمره عصر الكمبري المتأخر/ الأوردو فيشي المبكر - وتغطي صخور المتكون مساحة تقدر بمئات الآلاف من الكيلومترات المربعة من أرض المملكة، وتتغطى مباشـرة بتـتابع من الطفل المعروف باسم عضو الحنادر الطفلي، وتبلغ مساحة الجزء المنكشف من متكون ساق أكثر من 65000 كيلومتر مربع، وتقدر تغذية هذا الجزء المنكشف بمياه الأمطار بحوالي 260 مليون متر مكعب في السنة. ويمتاز الخزان المائي في متكون ساق بوفرة إنتاجـه بصفة عامـة، وتـتراوح ملوحتـه في شمال المملكة بين 500 و 1500 ملليجرام / لتر. يتغذى الساق بواسطة هطول الامطار على منكشفه الواقع شمال المملكة وقدرت كمية التغذية بحوالي 230 مليون متر مكعب /سنة ومن السيول حوالي 20 مليون متر مكعب/سنة، وتعد مياه الساق من النوعية الجيدة .\n"
        ),
    )

    data class LocationMarker(
        val name: String,
        val gov: String,
        val region: String,
        val type: String,
        val length: Double,
        val hight: Double,
        val crestHight: Double,
        val capacity: Double,
        val theDate: String,
        val latitude: Double,
        val longitude: Double,
        val iconResId: Int
    )

    @SuppressLint("MissingInflatedId", "SetTextI18n", "CutPasteId")
    override fun onCreate(savedInstanceState: Bundle?) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.decorView.systemUiVisibility = (
                View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                )
        }


        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_water_formations)
        supportActionBar?.hide()
        progressBar = findViewById(R.id.progressBar)

        mapView = findViewById(R.id.mapView)
        mapboxMap = mapView.getMapboxMap()

        // Set initial camera position
        val initialPosition = CameraOptions.Builder()
            .center(Point.fromLngLat(47.189224, 24.694291)) // Riyadh, Saudi Arabia
            .zoom(4.3)
            .build()

        val damsPosition = CameraOptions.Builder()
            .center(Point.fromLngLat(41.43849558314934, 20.27533228306812)) // Albaha, Saudi Arabia
            .zoom(6.3)
            .build()

        val valleysButton: Button = findViewById(R.id.Valleys)
        val valleysListLayout: LinearLayout = findViewById(R.id.valleys_list)

        val Dams: Button = findViewById(R.id.Dams)
        val damsListLayout = findViewById<LinearLayout>(R.id.dams_list) // Use your layout ID

        val subFormations: Button = findViewById(R.id.subFormations)
        val subFormationsList = findViewById<LinearLayout>(R.id.subFormations_list)

        val mainFormations: Button = findViewById(R.id.mainFormations)
        val mainFormationsList = findViewById<LinearLayout>(R.id.mainFormations_list)


        // Setup Home button
        val homeBtn: FloatingActionButton = findViewById(R.id.home)
        homeBtn.setOnClickListener {
            onBackPressed()
        }

        //START: Brief button
        val brief: Button = findViewById(R.id.brief)
        brief.setOnClickListener {

            valleysListLayout.visibility = View.GONE
            damsListLayout.visibility = View.GONE
            mainFormationsList.visibility = View.GONE
            subFormationsList.visibility = View.GONE
            isValleyStyleLoaded = !isValleyStyleLoaded
            mapboxMap.setCamera(initialPosition)

            //show all formations and dams
            setMarkers("dams.xlsx", R.drawable.droplet) // Data file
            setMapStyle("maps/water_formation/allformations.json") // shapes file

            val popupView = LayoutInflater.from(this).inflate(R.layout.formation_brief, null)

            val briefDialog = Dialog(this)
            briefDialog.setContentView(popupView)

            val displayMetrics = resources.displayMetrics
            val screenWidth = displayMetrics.widthPixels

            briefDialog.window?.setLayout(
                (screenWidth * 0.9).toInt(),
                LinearLayout.LayoutParams.WRAP_CONTENT
            )

            briefDialog.show()

            val closeButton = popupView.findViewById<Button>(R.id.closeButton)
            closeButton.setOnClickListener {
                briefDialog.dismiss() // This will close the dialog
            }
        }
        //END: Brief button


        //START: Valleys
        loadValleyNames()
        createValleyButtons()
        //END: Valleys

        mainFormations.setOnClickListener {
            if (mainFormationsList.visibility == View.GONE) {
                valleysListLayout.visibility = View.GONE
                isValleyStyleLoaded = !isValleyStyleLoaded
                damsListLayout.visibility = View.GONE
                subFormationsList.visibility = View.GONE
                mainFormationsList.visibility = View.VISIBLE
            } else {
                valleysListLayout.visibility = View.GONE
                mainFormationsList.visibility = View.GONE
            }
        }

        subFormations.setOnClickListener {
            if (subFormationsList.visibility == View.GONE) {

                valleysListLayout.visibility = View.GONE
                damsListLayout.visibility = View.GONE
                mainFormationsList.visibility = View.GONE
                isValleyStyleLoaded = !isValleyStyleLoaded

                subFormationsList.visibility = View.VISIBLE
            } else {
                valleysListLayout.visibility = View.GONE
                subFormationsList.visibility = View.GONE
            }
        }

        Dams.setOnClickListener {
            if (damsListLayout.visibility == View.GONE) {

                subFormationsList.visibility = View.GONE
                mainFormationsList.visibility = View.GONE
                valleysListLayout.visibility = View.GONE
                damsListLayout.visibility = View.VISIBLE
                isValleyStyleLoaded = !isValleyStyleLoaded

                mapboxMap.setCamera(damsPosition)
                setMarkers("dams.xlsx", R.drawable.droplet)

            } else {
                valleysListLayout.visibility = View.GONE
                damsListLayout.visibility = View.GONE
            }
        }

        valleysButton.setOnClickListener {
            val currentTime = System.currentTimeMillis()
            if (currentTime - lastClickTime > 500) {

                if (valleysListLayout.visibility == View.GONE) {

                    mainFormationsList.visibility = View.GONE
                    subFormationsList.visibility = View.GONE
                    valleysClickListener()

                    mapboxMap.setCamera(initialPosition)
                    setMapStyle("maps/saudi_geo/sahel.json",  true)

                    valleysListLayout.visibility = View.VISIBLE

                } else {
                    valleysListLayout.visibility = View.GONE
                }

                lastClickTime = currentTime
                isValleyStyleLoaded = !isValleyStyleLoaded
                toggleValleyLayersVisibility(isValleyStyleLoaded)
            }
        }

        //initial map show all formations and dams
        setMarkers("dams.xlsx", R.drawable.droplet)
        setMapStyle("maps/water_formation/allformations.json")

        pointAnnotationManager = mapView.annotations.createPointAnnotationManager().apply {
            addClickListener(this@WaterFormations)
        }


        mapboxMap.setCamera(initialPosition)

        val resetZoomBtn: FloatingActionButton = findViewById(R.id.reset_zoom)
        resetZoomBtn.setOnClickListener {
            mapboxMap.setCamera(initialPosition)
        }



        //START: Formation buttons
        formationsButtons(
            "saq",
            "تكوين الساق",
            "يمتد من شمال غرب المملكة ( الحدود الأردنية ) حتى نفوذ السر جنوبا , ويبلغ امتدادة 1200 كيلومتر , وهو يتكون من الأحجار الرملية التي تعو إلى العصر الكمبري , ويقدر عمر مياة الساق بين 22 الف إلى 28 الف سنة ,ويتراوح عمق المياه في تكوين الساق بين 100م في منطقة الجنوب إلى 1850م في القصيم.\n" + "،ويستفيد من الجزء الشرقي من التكوين منطقة القصيم مثل بريدة وعنيزة ومنطقة السر والأسياح وشرق حائل ومنطقة تبوك وتيماء. يعتبر أهم مكامن المياه في المملكة على الإطلاق، وذلك لأن متكون ساق يعلو صخور الدرع العربي المصمتة مباشرة بسمك متوسط يزيد على خمسمائة متر، ويغلب على تركيـبه الصخور الرملية عالية المسامية و النفاذية، وإن تخللتها في أجزائها العليا بعض راقات من الطفل (الصلصال الصحفي). ويتبع متكون ساق في عمره عصر الكمبري المتأخر/ الأوردو فيشي المبكر - وتغطي صخور المتكون مساحة تقدر بمئات الآلاف من الكيلومترات المربعة من أرض المملكة، وتتغطى مباشـرة بتـتابع من الطفل المعروف باسم عضو الحنادر الطفلي، وتبلغ مساحة الجزء المنكشف من متكون ساق أكثر من 65000 كيلومتر مربع، وتقدر تغذية هذا الجزء المنكشف بمياه الأمطار بحوالي 260 مليون متر مكعب في السنة. ويمتاز الخزان المائي في متكون ساق بوفرة إنتاجـه بصفة عامـة، وتـتراوح ملوحتـه في شمال المملكة بين 500 و 1500 ملليجرام / لتر. يتغذى الساق بواسطة هطول الامطار على منكشفه الواقع شمال المملكة وقدرت كمية التغذية بحوالي 230 مليون متر مكعب /سنة ومن السيول حوالي 20 مليون متر مكعب/سنة، وتعد مياه الساق من النوعية الجيدة .\n",
        )
        formationsButtons(
            "tabuk",
            "تكوين تبوك",
            "يمتد تكوين تبوك جنوب وشرق الحدود الاردنية والى وادي الرمة جنوبا , حيث تبلغ مساحتة 100 الف كيلومتر مربع , كما ينفصل التكوين عن بعضة البعض بالحزام الرملي لصحراء النفوذ الكبرى , هذا ويظهر تكوين تبوك الى الغرب من النفوذ الكبير في ثلاث مناطق وهي تبوك والطويل والجوف , وتستفيد منه المناطق السابقة في تكوين الساق عدا منطقة السر. تـرجع مجموعـة تبوك إلى العصرين الأوردو فيشي المتوسط / السيلوري ، وتـتكون المجمـوعـة من ثلاث وحدات من الصخور الرملية المتبادلـة مع ثلاث وحدات من الصخور الطفلية. ويـبلغ متوسط سمك الوحدات الرملية الحاملـة للمياه في هذه المجموعـة حوالي 200 متر وإن كان سمك المجمـوعـة يتجاوز الألف متر في بعض الأماكن. ويغطي الجزء المنكشف منها مساحة تقدر بأكثر من مائة ألف كيلو متر مربع ، ومياه تلك المجموعـة جيدة إذ تتراوح ملوحتها بين 400 إلى 600 ملليجرام / لتر في المتوسـط وتزداد الملوحـة في الاتجاه الجنوبي، وتعتمد مناطق تبوك والقصيم على مياه تلك المكامن بالإضافـة إلى مياه مكمن متكون ساق. ويختلف سمك تكوين تبوك من منطقة لاخرى تبعا لوجود جميع اجزائه او بعضا منها، ويبلغ سمكة 1070 م ويوجد منكشفه في مناطق تبوك وتيماء وحائل والقصيم ويعتبر من أغنى التكوينات الحاملة للماء بالمملكة . ويبلغ عمر المياه في متكون تبوك اكثر من ثلاثين الف سنة وتم تقدير المخزون بحوالي 1300 مليون متر مكعب."
        )
        formationsButtons(
            "wajid",
            "تكوين الوجيد",
            "يوجد في جنوب ووسط المملكة، وتستفيد منه منطقة وادي الدواسر.  يمتد مابين وادي نجران وشرورة في الجنوب و وادي الدواسر في الشمال لمسافة 300 كم ولا يزيد عرضة عن 100 كم , ويتكون من الاحجار الرملية ذات الحبيبات الخشنة والناعمة ترجع إلى حقب الحياة القديمة ’ كما تقع الصخور الرملية لتكوين الوجيد على الصخور النارية والمتحولة ويتراوح سمك تكوين الوجيد من 200 إلى 900 متر . تغطي صخوره مساحـة في جنوب غربي المملكة تقدر بحوالي عشرين ألف كيلو متر مربع، بسمك متوسط في حدود 400 متر، وإن كان ذلك السمك يزداد تدريجيا كلما اتجهنا شرقاً ليصل إلى قرابـة الألف متر. وتتراوح أعماق مياهه من 100 إلى 1100 متر كما يقدر عمر مياهه بحوالي 300 ألف سنـة أو أكثر. وتقل الملوحـة في مياه تكوين الوجيد عن 1000 ملليجرام / لتر، وقدرت كمية مياه الأمطار التي تغذي المتكون بنحو 500 مليون متر مكعب سنوياً. وتستغل مياه الوجيد في وادي الدواسـر منذ 1966م حيث تندفن صخوره تحت متكونات أحدث عمراً بين وادي الدواسـر ووادي نجران، وتندفع شرقاً تحت الأجزاء الغربيـة من الربع الخالي إلى مسافـة كبيرة محتفظـة بتركيبها الرملي، مما يزيد في إمكانيـة تلك المكامن المائـية التي تشبـه مياهها في خواصها الكيميائية والطبيـعية مياه مكمن متكون ساق."
        )
        formationsButtons(
            "minjur",
            "تكوين المنجور",
            "يقع تكوين المنجور وسط المملكة والى الشرق من تكوين الساق وتبلغ مساحتة نحو 6500 كيلومتر مربع , وهو يتكون من الاحجار الرملية ذات الاصل القاري المتعددة الطبقات وتوجد عليها طبقات رقيقة من الصخور الجيرية والطفل والجبس . وهو يعتبر من التكوينات العميقة نسبياً حيث يوجد على أعماق تصل لأكثر من 1800م،  وتستفيد منه منطقة الرياض وسدير والوشم والخرج والأفلاج والسليل. يرجع متكون المنجور في العمر إلى الترياسي المتأخر / الجوراسي المبكر ويتكون من الرمل الخشن عالي المسامية والنفاذيـة، ولذلك فهو مشبع بالمياه. وقد درست عينات من مياهه من بئر الشميسي في الرياض فوجد أن عمرها يرجع إلى ما بين 35 و 40 ألف سنـة، بينما يرجـع عمر متكون ضرما إلى الجوراسي المتوسط ويغلب على تركيبـه الطفل والطفل الكلسي والحجر الجيري، وتتحول تلك الصخور في الجزء الجنوبي من المملكة إلى صخور رملية مما يسمح بتشبعها بالمياه فتشكل مع متكون المنجور- الذي تعلوه بصورة لا توافقية- خزاناً مائياً واحداً يطلق عليه مكمن المنجور / ضرما وذلك جـنوب خط عـرض °20 شمالاً، وتتراوح نسبـة الأمـلاح في مياه ذلك الخزان المائي بين 400 و 1500 ملليجرام / لتر. وتزداد الملوحـة باتجاه الشرق وكذلك مع زيادة العمق. وتبلغ مساحة منكشف المنجور حوالي 2500 كيلومتر مربع كما تصل سماكـة التكوين إلى 400 متر تشمل طبقتين حاملتين للمياه تحت السطحيـة. يعتبر المنجور واحد من الخزانات الجوفية المهمة ذات المياه الغزيرة في المملكة حيث تخترقه الكثير جدا من الابار في منطقة الرياض وما حولها وهو ذو مسامية ونفاذية عالية جدا. وتختلف خصائصه الهيدروليكية بدرجة كبيرة من مكان لاخر يتغذى المنجور بواسطة هطول الامطار على منكشفه وقدرت كمية التغذية بحوالي 85 مليون متر مكعب سنويا على امتداد منكشفه."
        )
        formationsButtons(
            "biyadh",
            "تكوين البياض",
            "يمتد تكوين البياض على شكل شريط هلالي من وادي الدواسر جنوبا حتى وادي العتش شمالا لمسافة 650 كلم ويبلغ عرض منكشفة 50 كلم في وادي الدواسر. وتوجد اجزاءه المحصورة المغطاه بمختلف الرسوبيات في المنطقة الشرقية والشمالية الشرقيه والربع الخالي وتمتد داخل حدود قطر والكويت والعراق، ومعظم اجزائه المحصورة مغطاه بالاحجار الرمليه لتكوين الوسيع وفي معظم المناطق خاصة في المنكشفات لا يمكن الفصل بين البياض والوسيع حيث يكونان وحدة مائية واحدة، يحد البياض من الأسفل تكوين البويب المكون من الاحجار الجيرية مع الاحجار الرملية والطفل. تكوين البياض قاري الاصل من العصر الطباشيري الاسفل ويتكون اساسا من حبيبات الرمل والاحجار الرملية مع طبقات رقيقة من الطفل والمارل والدلومايت والحجر الحديدي وتتغير السحنة في اتجاه الشرق من احجار رملية الى رمليه طفلية الى احجار جيريه. يبلغ اقصى سمك للمتكون 625 متر ويقل سمكة كلما اتجهنا شمالا. نوعية الياه في المتكون مالحة الى شديدة الملوحة وتبلغ كمية الاملاح الذائبة قرب المنكشف حوالي 1500 ملجم/لتر بينما تصل الى اكثر من 6000 ملجم/لتر في المنطقة الشرقية، اما في منطقه الخرج فان المياه ذ ات نوعيه جيده وتبلغ الاملاح الذائبه حوالي 550 -900 ملجم / لتر. يستغل تكوين البياض في مناطق الخرج ووادي السهبا ووادي نساح وخريص."
        )
        formationsButtons(
            "wasii",
            "تكوين الوسيع",
            "تتألف صخور تكوين الوسيع ، من صخور رملية رقيقة نسبيا ، وطفل وعدسات من الكربونات . ويمتد منكشف الوسيع حوالي 1450 كم من الربع الخالي في اتجاه الشمال على شكل قوس ضخم يمر تحت الطرف الغربي من النفود الكبير . يوجد منكشف الوسيع في شكل مقطع كامل في خشم الوسيع الواقع شمال وادي السهبا ، يمتد منكشف الوسيع مسافة 1460 كم على شكل شريط هلالي من شمال وادي الدواسر حتى النفوذ الكبير بالشمال حيث يختفى تحت كثبانه ثم يظهر على سطح الارض ثانية وينكشف بالقرب من سكاكا حيث يعرف بحجر رمل سكاكا، ويعلوه احجار جيرية تابعة لتكوين العرمة. يشكل متكونا البياض والوسيع وحدة مائية واحدة ويعتبر من خرانات المياة الجوفية الممتازة في المملكة . متكون الوسيع قاري الاصل ترسب في العصر الطباشيري الاوسط ويتكون من حبيبات رملية غير متماسكه متوسطة الى خشنة. يتراوح سمك التكوين بين 200 و230 م  ويزداد سمكه تجاه الشمال حتى يبلغ 285 م بالقرب من سكاكا.  ويبلغ اقصى سمك له في الجنوب 600 م تحت الربع الخالي. يغذى المتكون مع متكون البياض منطقة الرياض و حفر.الباطن وقدر مجموع ما يستخرج من هذه التكوين بواقع 75 مليون متر مكعب. يقدر حجم المخزون في تكون الوسيع تقريبا حوالي 57000 مليون متر مكعب. قدرت كمية التغذية السنوية للتكوين من مياه الامطار والسيول حوالي 419 مليون متر مكعب. تغذي طبقة الوسيع - البياض جبال طويق , ويقدر عمر الماء عند المنكشف بالقرب من خريص بنحو 16 الف سنة ويرجع متكونا البياض والوسيع إلى العصر الطباشيري المبكر والمتوسط،. وعلى الرغم من ذلك فإن كلا المتكونين يغلب عليهما الصخور الرملية عالية المسامية والنفاذيـة، التي يمتد ظاهرها لمسافات كبيرة تتعدى الألف كيلومتر في الطول وعشرات الكيلومترات في العرض، ولذا فكلاهما مشبع بالمياه، وغالباً ما يتصل الخزانان ليكونا مكمناً مائياً واحداً يعرف بـاسم مكمن البياض - الوسيع، الذي يعتبر من أوفر مكامن المياه بالمملكة، وتتراوح نسبـة الأملاح في مياه هذا المكمن المائي بين 550 و 6000 ملليجرام / لتر. ويقدر عمر المياه عند المنكشف بالقرب من خريص بنحو 16 ألف سنـة."
        )
        formationsButtons(
            "radmaa",
            "تكوين أم الرضمة",
            " يمتد من الحدود العراقية والاردنية في الشمال الى جنوب وادي الدواسر لمسافة 1200 كم ، ويتكون من الحجر الحبيبي الطباشيري والدولومايت وبعض الطفل الذي ينتمي الى الاصل الحجري , ويتفاوت سمك التكوين بشكل عام من الغرب الى الشرق ومن الشمال الى الجنوب , وتختلف نوعية مياهه تبعاً لبعده عن المناطق الساحلية. وتستفيد منه الظهران وشدقم والخبر والدمام وحرض وبعض المناطق في الإحساء ووادي المياه.  يتبع متكون أم رضمة عصري الباليوسين المتأخر / الإيوسين المبكر ويتكون أساساً من صخور جيريـة تتحول بدورها إلى صخور رملية في الأجزاء الجنوبية الغربية من أرض المملكة. ويمتد ظاهر متكون أم رضمة في حزام يبلغ طوله 1200 كيلومتر، ويتراوح عرضه بين  60 و  120 كيلومتراً (من وادي الدواسر جنوباً إلى الحدود الشمالية للمملكة)، ثم يظهر مرة أخرى بتركيب صخري مغاير قليلاً في حوض وادي السرحان (حوض سكاكا- تبوك) من غرب عرعر إلى الحدود السعوديـة- الأردنيـة، ويمتد جنوباً من تلك الحدود إلى منطقـة الطبيق. ويبلغ متوسط سمك متكون أم رضمة في قطاعاتـه الظاهرة فوق سطح الأرض حوالي 250 متراً، ويزداد ذلك إلى حوالي 700 متر تحت سطح المنطقة الشرقية. والمتكون ملئ بحفر الإذابـة التي مكنتـه من تخزين كميات من مياه الأمطار على الرغم من قلة مسامية ونفاذيـة صخوره بصفة عامـة. ونوعـية المياه في متكون أم رضمـة جيدة بالقرب من طبقاته حيث يبلغ مجموع الأملاح الذائبـة بها حوالي 1000 ملليجرام / لتر، إلا أن ذلك يزداد شرقاً وشمالاً ليصل إلى 4000 ملليجرام / لتر. وتتدهور خصائص مياهـه في المناطق الساحلية تدهـوراً ملحوظاً وذلك نظراً لتسرب بعض مياه الخليج إليه مع وجود ألسنـة من المياه قليلة الملوحـة. وتقدر كمية مياه الأمطار التي تغذي هذا المكمن بنحو 2405 أمتار مكعبة سـنوياً. يعتبر تكوين أم الرضمة من أهم الخزانات الجوفية العذبة في المملكة حيث أن حجر الجير النقي ذو خصائص هيدروليكية لا مثيل لها في غيرها من التكاوين المائية فمساميته عالية ونفاذيته جيدة جدا إضافة ألي وجود العديد من الشقوق والكهوف اتحت سطحية التي تكونت بسبب إذابة الصخور الجيرية. يميل تكوين أم رضمه الي الانسياب الارتوازي التلقائي على طول ساحل الخليج العربي وفي المناطق المنخفضة. تؤثر عوامل عديدة على نوعية مياه أم رضمة منها نوعية مياه التغذية المتسربة والمعادن القابلة للذوبان في الصخور اضافة الى الى تداخل مياه البحر في المناطق الساحلية . ويبلغ متوسط مجموع الأملاح الذائبة حوالي 1000 ملجم/ لتر في المنكشف إلا أنها تسوء في المنطقة الساحلية لتصل إلى اكثر من 4000 ملجم/لتر. قدرت كمية اتغذية بحوالي 2406 مليون متر مكعب  بعضها من مياه الأمطار والسيول والباقي يأتي من تسرب الخزانات الجوفية."
        )
        formationsButtons(
            "neojen",
            "تكوين النيوجين",
            "ينتشر هذا التكوين في شرق المملكة بدءاً من وادي الدواسر جنوباً إلى وادي السرحان شمالاً , وهو يمتد ايضا تحت رمال الربع الخالي , ويتكون هذا التكوين من رسوبيات العصر الرباعي من الحجر الجيري وهو ذو اصل بحري ، وتعتمد الزراعة في وادي المياه ومنطقة الإحساء بشكل رئيس على هذا التكوين حيث تستمد معظم العيون الموجودة هناك مياهها منه. ينقسم التكوين إلى أربع طبقات وهي :متكون الهدروخ ويتكون من الطفل الطيني الأخضر وحجر الرمل الغريني الجيري والمارل الرمادي وبعض الجبس وحجر الجير الرملي، وهو يرتكز دون توافق على متكون الدمام ويبلغ سمكه حوال 85 كم، وعمره يتبع المبوسين المبكر. متكون الدام ويتكون من حجر الجير الرملي والمارل والطفل وقليل من حجر الرمل، ويعلو متكون الهدروخ وسمكه حوالي 90 م ويتبع عصر الميوسين الأوسط .متكون الهفوف ويتركب من حجر رملي ومارل رملي وحجر جيري رملي وكونجلوميرات ويصل سمكه إلى 95 م ويعلو متكون الدام، ويتبع عصر الميوسين المتأخر والبليوسين. متكون الخرج ويتركب من حجر الجير والجبس وطبقات من الكونجلوميرات والحصى والرمل الجبسي، ويصل سمكه إلى 28 م ويتبع عصر البليوسين. يزيد سمك هذه المتكونات عن 250 م في المنطقة الشرقية ويقل كلما اتجهنا إلى الغرب. ويعد تكوين النيوجين من التكوينات الهامة في منطقة الهفوف إذ يختزن كميات من كبيرة من المياه ومعظم مياه العيون والآبار في الإحساء تأتي من متكون النيوجين. تحوي هذه المكامن بين طبقاتها الكثير من أسطح التـعرية التي زادت من مساميتها ونفاذيتها الثانويتين فأصبحت تشكل أهم الخزانات المائيـة في منطقـة الأحساء حيث تتدفق العيون وتكثر الآبار. والخزان المائي في صخور هـذه المجموعـة هو في غالبيتـه خزان غير حبـيس، وإن كانت المياه تُحبَس في بعض أجزائه حبساً موضعياً نظراً لوجود بعض الراقات غير المنفذة بين تتـابع طبقاتـه. وتختلف نـوعيـة مياه خزانات صخور النيوجين من مكان إلى آخر باختلاف تركيب الصخور التي تحتويها، ويتراوح مجموع الأملاح المذابـة فيها بين 1000 و 4000 ملليجرام / لتر. وتقدر كمية التغذية بحوالي 328 مليون متر مكعب سنوياً."
        )
        formationsButtons(
            "dammam",
            "تكوين الدمام",
            "يمتد تكوين الدمام في مناطق متفرقة حول ساحل الخليج العربي , و يتكون من خمسة طبقات ( صخور ذات اصل بحري ) , غير ان هناك طبقتين فقط حاملتين للمياه وهما طبقة العلاة وطبقة الخبر , تتكون طبقة العلاة من الحجر الجيري الدلوميتي المسامي وفي أسفله طبقة مارل بينما تتكون طبقة الخبر من الحجر الجيري والحجر الجيري المارلي ، وتسفله طبقة مارل، وقد تعرضت الطبقتان لعوامل تعرية كيميائية ونتج منها شقوق وفجوات في كلتا الطبقتين مما أدى إلى زيادة نفاذيتها، وهناك اتصال مائي طبيعي بين الطبقتين وصناعي ناتج عن حفر الآبار خلال الطبقتين دون حجب إحداهما عن الأخرى ، ويتراوح سمك تكوين الدمام من 50 الى 75 متر  ويعتبر من أهم التكوينات المائية اقتصادياً نظراً لقلة عمقه وسهولة الحفر فيه ونوعية مياهه، وتستفيد منه الخبر والدمام والقطيف والهفوف. يظهر هذا المتكون في شرق المملكة ويرجـع إلى عصر الإيوسين المتوسط ويتكون أساساً من الحجر الجيري مع بعض راقات من الصلصال الكلسي والصفحي. ويعتبر متكون الدمام المكمن المائي الرئيس لشرقي الجزيرة العربية، وتظهر صخوره في حزام غير متصل يبلغ طوله حوالي 180 كيلومتراً، وعرضـه من حوالي خمسة كيلومترات إلى مائتي كيلومتر (من وادي السهباء في الجنوب إلى الحدود الشمالية للمملكة حيث يصل عرض الحزام إلى حوالى 200 كيلومتر). وتظهر صخور المتكون حول قبة الدمام بسمك يبلغ 30 متراً تقريباً حيث ينتهي بكسر هائل في تـتابـع الطبقات أدى إلى تعرض صخور ذلك المتكون للمزيد من أعمال التعريـة التي أكسبت ما تبقى من صخوره نفاذيـة ومساميـة ثانويـتـين، بالإضافـة إلى العديد من حفر الإذابـة التي زادت من قدرة تلك الصخور الجيريـة على خزن مياه الأمطار. مياه متكون الدمام غزيرة وهي مياه متوسطـة النوعيـة حيث تقل الأملاح الذائبـة فيها عن 2000 ملليجرام / لتر، إلا أن ملوحتها تزداد كلما اتجهنا شرقاً أو جـنـوباً حتى تصل إلى أكثر من 6000 ملليجرام / لتر في المناطق الساحلية بسبـب تداخل مياه الخليج العربي في صخور ذلك المكمن. ويقدر عمر المياه في متكون الدمام بنحو 25 ألف سنـة ويتراوح سمك التكوين من 50 إلى 75 متراً. ويبلغ معدل التغذية السـنوية من مياه الأمطار 1601 مليون متر مكعب. ويستغل تكوين الدمام في المنطقة الشرقية والبحرين لأعراض الشرب الزراعية وتتراوح نوعية مياه التكوين من متوسطة إلى رديئة، وتسوء نوعيتها كما اتجهنا شرقاً أو جنوباً، ففي الغرب تبلغ 1000 ملجم/لتر، بينما في المناطق الساحلية تصل 6000 ملجم/لتر، وقدرت كمية المخزون في الأجزاء غير المحصورة بحوالي 5000 مليون متر مكعب بينما قدرات التغذية السنوية بحوالي 200 مليون متر مكعب."
        )
        formationsButtons(
            "jilh",
            "تكوين الجله",
            "يتبع العصر الترياسي ويتكون من الأحجار الرملية والطفل وبعض الأحجار الجيرية، ويمتد منكشفه على هيئة شريط ضيق عرضه يتراوح بين 8 الى 12 كم ويعلو الجله تكوين المنجور ويعلوه طفل سدير. يصل سمك الجله إلى 326 م. حفرت عدة آبار في مدينة الرياض تخترق منكتشف الجله إلا أن مياهها رديئة حيث بلغت ملوحته أكثر من 6000 ملجم/لتر في القصيم."
        )
        formationsButtons(
            "khuf",
            "تكوين الخف",
            "يتبع عصر البرمي العلوي ويتركب أساساً من حجر الرمل وحجر الجير والطفل، وينكشف على طول حزام ضيق يحاذي الحافة الشرقية للدرع العربي ويبلغ سمكه حوالي 171 م. يغطي الخف تكوين الساق في القصيم وصخور الدرع العربي في الوسط. تتراوح نوعية مياهه ما بين 2000 – 3000 ملجم/لتر في القويعية، وتستغل مياهه في مناطق الدوادمي والقويعية والقصيم ووادي الدواسر."
        )
        formationsButtons(
            "joof",
            "تكوين الجوف",
            "يتبع عصر الديفوني السفلى وتتكون طبقاته من صخور الطفل الغريني وحجر الرمل وحجر الجير والدلوميت. ويقع فوق متكون تبوك. وينكشف شمال شرق النفود ويمتد حتى الأردن. ويبلغ طول المنكشف 100 كم، ويحتفظ هذا التكوين بكميات متوسطة من الماء. يستغل المتكون في منطقة الجوف، ويبلغ معامل النقولية له 95 م /يوم، وملوحة مياهه 1200 ملجم/لتر. تغلب الصخور الرملية ذات الحبيبات الناعمة والمتوسطة على محتويات تكوين الجوف ويبلغ سمكه في المنطقة بين سكاكا وعرعر 431 متر إلا أن سمكه يصل في سكاكا إلى 700 متر وتتراوح إنتاجيته من المياه بين 16 – 24 لتر / ثانية كما تختلف الناقلية في الخزان حيث تتراوح بين 0.0011 و 0.002 م/ ثانية ويصل تركيز الأملاح في مياهه بالجوف إلى 700 ملجم/لتر."
        )
        formationsButtons(
            "darmaa",
            "تكوين ضرماء",
            "يتبع الجوراسي الأوسط ويتكون من حجر الجير والطفل وتتغير سحنته إلى حجر رملي كلما اتجهنا إلى الشمال أو الجنوب. يمتد منكشفه لمسافة 900 كم، ويصل سمك التكوين إلى 375 م. وهو يعلو متكون مرات ويسفل متكون طويق، ويعتبر من التكاوين المائية الجيدة حينما تسود السحنة الرملية. يستغل المتكون في وادي الدواسر والزلفى وتتراوح ملوحة مياهه بين 400-500 ملجم/لتر."
        )
        formationsButtons(
            "skaka",
            "تكوين سكاكا",
            "يتبع العصر الكريتاوي (الطباشيري) الأوسط وله أهمية كبيرة في منطقة سكاكا . يتألف تكوين سكاكا من صخور رملية ويبلغ سمكه في سكاكا نحو 285 متر وإنتاجه في إقليم سكاكا 18 لتر / ثانية ويتراوح الناقلية فيه عند المنكشف بين 0.0003 و 0.0028 م/ ثانية ويصل تركيز الأملاح في مياهه بمحافظة سكاكا إلى 600 ملجم/ لتر ."
        )
        formationsButtons(
            "aruma",
            "تكوين العرمه",
            "يتبع هذا التكوين العصر الكريتاوي العلوي ويوجد تحت تكوين أم رضه وفوق الوسيع. ينكشف لمسافة 1600 كم من وادي الدواسر جنوباً حتى الحدود العراقية، ويتكون من الدلوميت والطفل مع بعض حجر الرمل ويصل سمكه إلى 142 م. ويعتبر من التكاوين الجيدة وهو على اتصال بتكوين أم رضمه ولكنه أقل أهمية منه. مياه العرمة جيدة وتستغل في منطقة حفر الباطن وفي أجزاء من المنطقة الشرقية وفي رفحة وبدنه وتتراوح ملوحة مياهه بين 850 – 2100 ملجم / لتر."
        )

        //END: Formation Buttons

        setupCombinedClickListener()
    }

    //START: Valleys Functions
    private fun toggleValleyLayersVisibility(showValleys: Boolean) {
        mapboxMap.getStyle { style ->
            valleysList.forEach { (valleyName, _) ->
                val layerId = valleyName
                style.getLayerAs<LineLayer>(layerId)?.visibility(
                    if (showValleys) Visibility.VISIBLE else Visibility.NONE
                )
            }
        }
        pointAnnotationManager.deleteAll() // delete Dams icons
        progressBar.visibility = View.GONE
    }

    @SuppressLint("InflateParams", "SetTextI18n")
    private fun showValleyPopup(feature: Feature) {
        feature.getStringProperty("name_ar")?.let { nameAr ->
            feature.getNumberProperty("length")?.let { length ->

                val popupView = LayoutInflater.from(this).inflate(R.layout.popup_layout, null)
                popupView.findViewById<TextView>(R.id.title).text = nameAr
                popupView.findViewById<TextView>(R.id.description).text =
                    "الأسم: $nameAr\n" +
                            "الطول: ${length.toDouble()} كم"

                // Create the dialog
                val dialog = Dialog(this)
                dialog.setContentView(popupView)

                // Get the screen width
                val displayMetrics = resources.displayMetrics
                val screenWidth = displayMetrics.widthPixels

                // Set the dialog window attributes for position
                val window = dialog.window
                if (window != null) {
                    val layoutParams = WindowManager.LayoutParams()
                    layoutParams.copyFrom(window.attributes)
                    layoutParams.width = (screenWidth * 0.3).toInt()
                    layoutParams.height = LinearLayout.LayoutParams.WRAP_CONTENT
                    layoutParams.gravity = Gravity.TOP or Gravity.LEFT
                    layoutParams.x = 0 // x position
                    layoutParams.y = 0 // y position
                    layoutParams.dimAmount = 0f // No dimming

                    window.attributes = layoutParams
                }

                dialog.show()

                // Find the button and set a click listener to close the dialog
                val closeButton = popupView.findViewById<Button>(R.id.closeButton)
                closeButton.setOnClickListener {
                    dialog.dismiss()
                }
            }
        }
    }

    private fun loadValleyNames() {
        valleysList.forEach { (valleyName, valleyData) ->
            val geoJsonPath = valleyData.first
            val geoJsonString = loadJsonFromAsset(geoJsonPath)
            val featureCollection = FeatureCollection.fromJson(geoJsonString)
            val nameAr = featureCollection.features()?.firstOrNull()?.let {
                it.getStringProperty("name_ar") ?: it.getStringProperty("Name") ?: valleyName
            }
            if (nameAr != null) {
                valleyNamesMap[valleyName] = nameAr
            }
        }
    }

    private fun createValleyButtons() {
        val layout = findViewById<LinearLayout>(R.id.valleys_list)
        valleyNamesMap.forEach { (valleyName, nameAr) ->
            val button = Button(this).apply {
                text = nameAr // Assuming this is the name_ar of the valley
                gravity = Gravity.CENTER
                background = ContextCompat.getDrawable(this@WaterFormations, R.drawable.sub_btn_menu)
                textSize = 20f

                // Set LayoutParams with margins
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).also {
                    val marginInPixels = 5.dpToPx(this@WaterFormations)
                    it.setMargins(marginInPixels, marginInPixels, marginInPixels, marginInPixels)
                }

                setOnClickListener { onValleyButtonClick(valleyName) }
            }
            layout.addView(button)
        }
    }

    private fun Int.dpToPx(context: Context): Int {
        return (this * context.resources.displayMetrics.density).toInt()
    }

    private fun onValleyButtonClick(valleyName: String) {
        // Show popup
        val (geoJsonPath, _) = valleysList[valleyName] ?: return
        val geoJsonString = loadJsonFromAsset(geoJsonPath)
        val featureCollection = FeatureCollection.fromJson(geoJsonString)
        val firstFeature = featureCollection.features()?.firstOrNull() ?: return
        showValleyPopup(firstFeature)

        // Update valley colors
        updateValleyColors(valleyName)
    }

    private fun updateValleyColors(selectedValley: String) {
        mapboxMap.getStyle { style ->
            valleysList.forEach { (valleyName, _) ->
                val layerId = valleyName
                style.getLayer(layerId)?.let { layer ->
                    (layer as LineLayer).lineColor(
                        if (valleyName == selectedValley) "#FF0000" else "#0000FF"
                    )
                }
            }
        }
    }

    private fun valleysClickListener(){
        mapboxMap.addOnMapClickListener { point ->
            val screenCoordinate = mapboxMap.pixelForCoordinate(point)
            val queryOptions = RenderedQueryOptions(
                valleysList.keys.map { it }, null // Layer IDs, no additional filter
            )
            mapboxMap.queryRenderedFeatures(screenCoordinate, queryOptions) { result ->
                if (result.isValue && result.value!!.isNotEmpty()) {
                    val queriedFeature = result.value!![0]
                    val feature = queriedFeature.feature // Extract Feature from QueriedFeature
                    showValleyPopup(feature)
                }
                result.isValue && result.value!!.isNotEmpty()
            }
            true
        }
    }
    //END: Valleys Functions

    //START: Dams Functions

    private fun setMarkers(excelFileName: String, iconResId: Int) {
        progressBar.visibility = View.VISIBLE  // Show the ProgressBar

        setMapStyle("maps/saudi_geo/sahel.json")

        // Launch a coroutine in the background
        CoroutineScope(Dispatchers.IO).launch {
            val markers = readLocationMarkersFromExcel(excelFileName, iconResId)

            withContext(Dispatchers.Main) {
                pointAnnotationManager.deleteAll()
                markers.forEach { addMarkerWithPopup(it) }
                progressBar.visibility = View.GONE  // Hide the ProgressBar

                if (!damButtonsCreated) {
                    createDamButtons()  // Only add this line once
                    damButtonsCreated = true
                }
            }
        }
    }

    private fun addMarkerWithPopup(marker: LocationMarker) {
        val point = Point.fromLngLat(marker.longitude, marker.latitude)
        val iconId = resources.getResourceEntryName(marker.iconResId)
        val pointAnnotationOptions = PointAnnotationOptions()
            .withPoint(point)
            .withIconImage(iconId)
            .withIconSize(0.5) // Adjust size as needed

        val annotation = pointAnnotationManager.create(pointAnnotationOptions)
        annotationDataMap[annotation.id] = marker
        damAnnotations[marker.name] = annotation

    }

    @SuppressLint("DiscouragedApi", "SimpleDateFormat")
    private fun readLocationMarkersFromExcel(fileName: String, iconResId: Int): List<LocationMarker> {
        val markers = mutableListOf<LocationMarker>()
        try {
            val inputStream = assets.open("data/$fileName")
            val workbook = XSSFWorkbook(inputStream)
            val sheet = workbook.getSheetAt(0)
            val dateFormat = SimpleDateFormat("dd/MM/yyyy HH:mm:ss") // Set your date format here

            for (row in sheet) {
                if (row.rowNum == 0) continue

                if (fileName !== "Histroical.xlsx") {
                    val region = row.getCell(0).stringCellValue
                    val gov = row.getCell(1).stringCellValue
                    val name = row.getCell(2).stringCellValue
                    val type = row.getCell(3).stringCellValue
                    val length = row.getCell(4).numericCellValue
                    val hight = row.getCell(5).numericCellValue
                    val crestHight = row.getCell(6).numericCellValue
                    val capacity = row.getCell(7).numericCellValue
                    val theDate = row.getCell(8).stringCellValue
                    val latitude = row.getCell(9).numericCellValue
                    val longitude = row.getCell(10).numericCellValue
                    markers.add(
                        LocationMarker(
                            name,
                            gov,
                            region,
                            type,
                            length,
                            hight,
                            crestHight,
                            capacity,
                            theDate,
                            latitude,
                            longitude,
                            iconResId
                        )
                    )
                } else {
                    val dateString = row.getCell(0).stringCellValue
                    val date: Date? = try {
                        dateFormat.parse(dateString)
                    } catch (e: ParseException) {
                        null
                    }
                    if (date == null) continue
                    val region = row.getCell(0).stringCellValue
                    val gov = row.getCell(1).stringCellValue
                    val name = row.getCell(2).stringCellValue
                    val type = row.getCell(3).stringCellValue
                    val length = row.getCell(4).numericCellValue
                    val hight = row.getCell(5).numericCellValue
                    val crestHight = row.getCell(6).numericCellValue
                    val capacity = row.getCell(7).numericCellValue
                    val theDate = row.getCell(8).stringCellValue
                    val latitude = row.getCell(9).numericCellValue
                    val longitude = row.getCell(10).numericCellValue
                    markers.add(
                        LocationMarker(
                            name,
                            gov,
                            region,
                            type,
                            length,
                            hight,
                            crestHight,
                            capacity,
                            theDate,
                            latitude,
                            longitude,
                            iconResId
                        )
                    )

                }
            }
            workbook.close()

        } catch (e: IOException) {
            // Handle IOException
            // Log the error or show a message to the user
        }

        return markers
    }

    override fun onAnnotationClick(annotation: PointAnnotation): Boolean {
        val markerData = annotationDataMap[annotation.id] // Retrieve data from the map
        if (markerData != null) {
            damsPopup(
                markerData.name,
                markerData.gov,
                markerData.region,
                markerData.type,
                markerData.length,
                markerData.hight,
                markerData.crestHight,
                markerData.capacity,
                markerData.theDate
            )
        }
        return true
    }

    @SuppressLint("InflateParams", "SetTextI18n")
    private fun damsPopup(name: String, gov: String, region: String, type: String, length: Double, hight: Double, crestHight: Double, capacity: Double, theDate: String, ) {

        // Inflate the popup view
        val theCapacity = String.format("%.0f", capacity)

        val popupView = LayoutInflater.from(this).inflate(R.layout.popup_layout, null)
        popupView.findViewById<TextView>(R.id.title).text = name
        popupView.findViewById<TextView>(R.id.description).text =
            "اسم السد: $name" + "\n" +
                    "الموقع: " + gov + "\n" +
                    "المحافظة: " + region + "\n" +
                    "ارتفاع السد: " + hight + " متر " + "\n" +
                    "طول السد: " + length.toInt() + " متر " + "\n" +
                    "سعة السد: " + theCapacity + " متر مكعب " + "\n" +
                    "نوع السد: " + type + "\n" +
                    "انشاء السد: " + theDate
        // Create the dialog
        val dialog = Dialog(this)
        dialog.setContentView(popupView)

        // Get the screen width
        val displayMetrics = resources.displayMetrics
        val screenWidth = displayMetrics.widthPixels

        // Set the dialog window width to 70% of the screen width
        val window = dialog.window
        if (window != null) {
            val layoutParams = WindowManager.LayoutParams()
            layoutParams.copyFrom(window.attributes)
            layoutParams.width = (screenWidth * 0.3).toInt()
            layoutParams.height = LinearLayout.LayoutParams.WRAP_CONTENT
            layoutParams.gravity = Gravity.TOP or Gravity.LEFT
            layoutParams.x = 0
            layoutParams.y = 0
            layoutParams.dimAmount = 0f // No dimming

            window.attributes = layoutParams
        }
        dialog.show()

        val closeButton = popupView.findViewById<Button>(R.id.closeButton)
        closeButton.setOnClickListener {
            dialog.dismiss()
        }
    }

    private fun createDamButtons() {
        val damsListLayout = findViewById<LinearLayout>(R.id.dams_list)

        // Clear existing buttons
        damsListLayout.removeAllViews()

        annotationDataMap.values.forEach { marker ->
            val button = Button(this).apply {
                text = marker.name
                gravity = Gravity.CENTER
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).apply {
                    val marginInPixels = 5.dpToPx(this@WaterFormations)
                    setMargins(marginInPixels, marginInPixels, marginInPixels, marginInPixels)
                }
                background = ContextCompat.getDrawable(this@WaterFormations, R.drawable.sub_btn_menu)
                textSize = 20f
                setOnClickListener { onDamButtonClick(marker.name) }
            }
            damsListLayout.addView(button)
        }
    }

    private fun onDamButtonClick(damName: String) {
        val marker = annotationDataMap.values.firstOrNull { it.name == damName }

        marker?.let {
            damsPopup(it.name, it.gov, it.region, it.type, it.length, it.hight, it.crestHight, it.capacity, it.theDate)
            updateDamColors(damName)
        }
        updateDamColors(damName)

    }

    private fun updateDamColors(selectedDamName: String) {
        damAnnotations.forEach { (damName, annotation) ->
            val iconId = if (damName == selectedDamName) "red_droplet" else "droplet"
            annotation.iconImage = iconId
            pointAnnotationManager.update(annotation)
        }
    }

    //END: Dams Functions

    //START: Formations Functions
    @SuppressLint("DiscouragedApi")
    private fun formationsButtons(name: String, title: String, description: String) {
        val formationBtnId = resources.getIdentifier(name, "id", packageName)
        val initialPosition = CameraOptions.Builder()
            .center(Point.fromLngLat(47.189224, 24.694291)) // Riyadh, Saudi Arabia
            .zoom(4.3)
            .build()

        if (formationBtnId != 0) {
            val element: Button = findViewById(formationBtnId)
            element.setOnClickListener {
                pointAnnotationManager.deleteAll() // delete Dams icons
                mapboxMap.setCamera(initialPosition)
                setMapStyle("maps/water_formation/$name.json")
                showPopup(title, description)
            }
        } else {
            // Handle the case where the resource is not found
            Log.e("FormationsButtons", "No view found with ID name: $name")
        }
    }

    @SuppressLint("InflateParams")
    private fun handlePolygonClick(title: String, description: String) {
        val popupView = LayoutInflater.from(this).inflate(R.layout.polygon_popup_layout, null)
        val tvTitle = popupView.findViewById<TextView>(R.id.tvTitle)
        val tvDescription = popupView.findViewById<TextView>(R.id.tvDescription)
        val btnClose = popupView.findViewById<Button>(R.id.btnClose)

        tvTitle.text = title
        tvDescription.text = description

        val popupWindow = PopupWindow(popupView,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            LinearLayout.LayoutParams.WRAP_CONTENT,
            true) // True for focusable

        btnClose.setOnClickListener { popupWindow.dismiss() }

        // Show the popup window
        popupWindow.showAtLocation(popupView, Gravity.CENTER, 0, 0)
    }

    //END: Formations Functions

    @SuppressLint("InflateParams")
    private fun showPopup(title: String, description: String) {
        // Inflate the popup view
        val popupView = LayoutInflater.from(this).inflate(R.layout.popup_layout, null)
        popupView.findViewById<TextView>(R.id.title).text = title
        popupView.findViewById<TextView>(R.id.description).text = description

        // Create the dialog
        val dialog = Dialog(this)
        dialog.setContentView(popupView)

        // Get the screen width
        val displayMetrics = resources.displayMetrics
        val screenWidth = displayMetrics.widthPixels

        // Set the dialog window width to 70% of the screen width
        dialog.window?.setLayout(
            (screenWidth * 0.9).toInt(),
            LinearLayout.LayoutParams.WRAP_CONTENT
        )

        // Show the dialog
        dialog.show()

        // Find the button and set a click listener to close the dialog
        val closeButton = popupView.findViewById<Button>(R.id.closeButton)
        closeButton.setOnClickListener {
            dialog.dismiss() // This will close the dialog
        }
    }

    private fun setupCombinedClickListener() {
        mapboxMap.addOnMapClickListener { point ->
            val screenCoordinate = mapboxMap.pixelForCoordinate(point)

            // Check for polygon features
            val polygonOptions = RenderedQueryOptions(polygonInfo.keys.toList(), null)
            var featureFound = false
            mapboxMap.queryRenderedFeatures(screenCoordinate, polygonOptions) { polygonExpected ->
                polygonExpected.value?.let { features ->
                    if (features.isNotEmpty()) {
                        val feature = features.first()
                        val sourceLayer = feature.sourceLayer

                        Log.d("MapClick", "Polygon Feature: $feature")
                        Log.d("MapClick", "Polygon Source Layer: $sourceLayer")

                        polygonInfo[sourceLayer]?.let { (title, description) ->
                            handlePolygonClick(title, description)
                            featureFound = true
                        }
                    }
                }
            }

            if (featureFound) return@addOnMapClickListener true

            // Check for valley features
            val valleyOptions = RenderedQueryOptions(valleysList.keys.map { it }, null)
            mapboxMap.queryRenderedFeatures(screenCoordinate, valleyOptions) { valleyExpected ->
                if (valleyExpected.isValue && valleyExpected.value!!.isNotEmpty()) {
                    val queriedFeature = valleyExpected.value!![0]
                    val feature = queriedFeature.feature
                    showValleyPopup(feature)
                    featureFound = true
                }
            }

            if (featureFound) return@addOnMapClickListener true

            false
        }
    }

    private fun loadJsonFromAsset(filename: String): String {
        return assets.open(filename).bufferedReader().use { it.readText() }
    }

    private fun setMapStyle(assetPath: String, loadValleys: Boolean = false) {
        try {
            val styleJson = loadJsonFromAsset(assetPath)
            mapboxMap.loadStyleJson(styleJson) { style ->

                // Define your icon resources
                val iconResources = listOf(R.drawable.droplet, R.drawable.red_droplet )

                iconResources.forEach { iconResId ->
                    val iconDrawable = ContextCompat.getDrawable(this, iconResId)
                    iconDrawable?.let {
                        val iconBitmap = drawableToBitmap(it)
                        val iconId = resources.getResourceEntryName(iconResId)
                        style.addImage(iconId, iconBitmap)
                    }
                }

                if (loadValleys) {
                    // Adding GeoJSON layers for valleys
                    valleysList.forEach { (valleyName, valleyData) ->
                        val (geoJsonPath, color) = valleyData
                        val geoJsonString = loadJsonFromAsset(geoJsonPath)
                        val sourceId = "source-$valleyName"
                        val layerId = valleyName

                        if (style.getSource(sourceId) == null) {
                            val geoJsonSource = geoJsonSource(sourceId) {
                                featureCollection(FeatureCollection.fromJson(geoJsonString))
                            }
                            style.addSource(geoJsonSource)
                        }

                        if (style.getLayer(layerId) == null) {
                            val lineLayer = LineLayer(layerId, sourceId).apply {
                                lineCap(LineCap.ROUND)
                                lineJoin(LineJoin.ROUND)
                                lineColor(color)
                                lineWidth(3.0)
                            }
                            style.addLayer(lineLayer)
                        }
                    }
                    isValleyStyleLoaded = true
                }
            }
        } catch (e: Exception) {
            Log.e("WaterFormations", "Error setting map style: ${e.message}")
        }
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
