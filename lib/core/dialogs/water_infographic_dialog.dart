import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';

import '../widgets/map_view_platform.dart';

class WaterInfographicDialog extends StatelessWidget {
  const WaterInfographicDialog({super.key});

  static Future<void> show(BuildContext context) async {
    setModalOpenWeb(true);
    try {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => const WaterInfographicDialog(),
      );
    } finally {
      setModalOpenWeb(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.85;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
        ),
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(maxHeight: size.height * 0.92),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF6EE),
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.40),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'مصادر المياه في المملكة العربية السعودية',
                      style: TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: AppColors.borderBrown, thickness: 1.5),
              const SizedBox(height: 8),

              // Scrollable content with text and 10 infographics
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'مقدمة وتحديات المياه',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'تفتقر المملكة إلى الأنهار الجارية والأمطار الغزيرة المنتظمة وتعاني بحكم طبيعتها القاحلة وموقعها الجغرافي من شح وندرة مصادر المياه وتعتبر ثالث أكبر مستهلك للمياه حيث يشكل النمو السكاني المضطرد وازدياد الطلب على المياه مشكلة كبيرة. تواجه المملكة تحديات كبيرة نظراً للاستخدام غير المستدام لموارد المياه، فضلاً عن محدودية مخزون المياه الجوفية غير المتجددة، التي تشهد استنزافاً متسارعاً. وفي ظل الظروف المناخية القاحلة، تعد المياه المتجددة نادرة، علماً بأن الطلب المرتفع على المياه في القطاعين الزراعي والصناعي يفاقم من مشكلة ندرة المياه. وتمثل المياه وخدمات الصرف الصحي في القطاع الحضري تكلفة مرتفعة على الدولة، كما يتطلب القطاع تحسين الأوضاع المؤسسية وآليات الحوكمة. الإستراتيجية الشاملة للمياه تعمل على دمج التوجهات والسياسات والتشريعات والممارسات في قطاع المياه لمواجهة التحديات الرئيسية وإعادة هيكلة قطاع المياه.\n'
                        'تتمثل مشاكل المياه في التلوث الناشئ عن استخدام الأسمدة الكيماوية والمبيدات وتصريف مياه المجاري في بطون الأودية وحفر الآبار العشوائية التي تؤدي إلى إهدار كميات كبيرة من المياه في الطبقات التي يتم اختراقها أثناء الحفر، علاوة على ذلك ما زالت معظم المزارع التقليدية تعتمد على الري بالغمر وبالتالي تستهلك كميات كبيرة من المياه مقارنة بالمزارع المتخصصة التي تعتمد على الري بالرش أو بالتنقيط، هذا بدوره أدى الى ازدياد الطلب على المياه، مما سبب في وجود فجوة واضحة بين الطلب على المياه والكميات المتاحة من المياه السطحية والجوفية ومياه التحلية ومياه الصرف الصحي المعالجة، الأمر الذي أدى زيادة السحب من المخزون المائي الاستراتيجي. وعلى ضوء ماسبق ذكره، قامت المملكة بإنشاء حوالي 574 سداً حتى نهاية عام 1444 هـ كمحاولة لحماية التجمعات السكانية والطرق الزراعية من السيول وتخفيف أضرارها للتربة ولاستخدامها في زيادة منسوب الطبقات الحاملة للمياه ولتأمين مياه الري للأغراض الزراعية. وسعيا لإيجاد بعض الحلول أطلقت وزارة البيئة والمياه الزراعة برنامج قطرة والذي يهدف إلى ترشيد استهلاك المياه لتحقيق الحفاظ عليها. وعموما يتمّ تأمين المياه من أربعة مصادر: المياه السطحية وتشمل العيون والأودية والسدود، المياه الجوفية وتشمل القريبة من السطح (المتجددة) والعميقة (غير المتجددة)، مياه الصرف المعالجة، ومياه البحر المحلاة.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          'المياه السطحية',
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.solidBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'هي المياه الناتجة عن جريان الأودية والشعاب الناشئة من هطول الأمطار والتي تتجمع في بحيرات خلف السدود التي يتم إنشاؤها، ويمكن أن تتجمع في منخفضات طبيعية أو صناعية على سطح الأرض. وتنقسم أحواض التصريف بصفة رئيسية في المملكة إلى قسمين: أحواض تصريف خارجية يتم تصريف مياهها خارج منطقة تساقط الأمطار تجاه البحر وأحواض تصريف داخلية حيث تصرف مياهها في أحواض داخلية في اتجاه الشرق. وعموماً فإن المياه السطحية تفقد إما بفعل البخر الشديد أو التسرب إلى باطن الأرض، ويمثل هذا الجزء نسبة بسيطة من كميات مياه الأمطار التي تتحول في الغالب إلى مياه جارية على شكل فيضانات بعد فترة وجيزة من هطول الأمطار والتي تفقد إما في البحر أو إلى رمال الصحراء. إن معدل هطول الأمطار منخفض (30 – 300 ملم) وتختلف كمية الأمطار بين المناطق والسنوات، الأمر الذي يؤدي إلى انتشار ظاهرة الجفاف في معظم مناطق المملكة، عدا منطقة جبال الحجاز وعسير.\n'
                        'العيون : تضم المملكة العديد من العيون المائيَّة، والتي تُعد مصدراً للمياه السطحيّة، إذ تمّ تدفقها بشكل طبيعي دون تدخُّل من باطن الأرض وتنقسم إلى مياه عذبة صالحة للشرب وللاستخدام البشريّ، ومياه كبريتيّة حارّة صالحة للاستعمال العلاجيّ.\n'
                        'عموما توجد المياه السطحية بشكل أكبر في المنطقتين الجنوبية والغربية، وبشكل أقل في المناطق الأخرى من المملكة وقدرت المياه السطحية الممكن استغلالها بحوالي 8 مليار متر مكعب الى عام 2023م.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          'الأودية',
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.solidBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'تتميز المملكة بالمناخ والتضاريس الصحراوية المختلفة من الجبال والهضاب والتلال، وبالتالي فهي بيئة خصبة لوجود الأودية، تخترق صخور الدرع العربي والمسطح العربي العديد من الأودية وتختلف مساحات مناطق تجمع تلك الأودية. توجد مناطق تغذية الأودية عادة في مناطق مرتفعة في جبال السروات وتصب مياه الأودية أما في البحر الأحمر غربا أو في نفود ورمال الصحاري وسط المملكة.ومن أهم أودية الدرع العربي فاطمة وحجر والعقيق والفرع وخليص ونعمان ورابغ والحمض والليث وجيزان وموهد ولجب ودوقة وأبها، أما الأودية التي تسيل شرقاً فأهمها أودية الرمة، السرحان، الباطن، الدواسر، أبا القور، تثليث، رنيه وبيشة. كما يوجد عدد من الأودية في وسط المملكة ومنها أودية حنيفة و السهبا وسمنان وبرك والركا والسرة والعمق والحوطة ونساح.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          'السدود',
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.solidBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'تقام السدود في المملكة لتغذية الطبقات الجوفية، توفير المياه للآبار في المناطق الزراعية حولها، تأمين مياه الشرب لبعض المناطق من خلال محطات التنقية المقامة عليها، تأمين مياه الري للأغراض الزراعية، وحماية المدن والقرى من أخطار السيول وكوارث الفيضانات. أما عدد السدود في المملكة فيبلغ 574 سداً بإجمالي طاقة تخزينية نحو 2.6 مليار متر مكعب موزعة على كافة المناطق ومن أهمها سد الملك فهد في بيشة و سد وادي حلي بمكة المكرمة وسد وادي رابغ بمكة المكرمة وسد وادي بيش بجازان وسد الليث بمكة المكرمة وسد المضيق بنجران وسد جازان وسد قاع حظوظا بالمدينة المنورة. شُيدت أكثر السدود فوق الدرع العربي والمسطح العربي ، موزعة على النحو التالي: عسير 117 سدًا، الرياض 103، مكة 57، الباحة 48، حائل 46، المدينة 41، نجران 27، القصيم 18، تبوك 16، جازان 13، الحدود الشمالية 11، الجوف 10، الشرقية 1. ونظراً لاختلاف تضاريس المملكة وحجم الأودية فيها تعددت نوعية السدود المقامة والتي تنحصر في السدود الخرسانية والسدود الترابية والسدود الركامية والسدود الجوفية. حتى نهاية 2023 م بلغ إجمالي عدد السدود في المملكة 574 سداً وبسعة تخزينية قدرها 2.6 مليار متر مكعب. أن السدود المقامة لغرض التعويض أكثر انتشاراً، حيث بلغ عددها 282 سداً حتى عام 2023م، ، يليها السدود المقامة لغرض التحكم وبلغ عددها 246 سداً، كما بلغ عدد السدود المقامة لأغرض الشرب 46 سداً.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          'مياه الصرف الصحي المعالجة (المياه المجددة)',
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.solidBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'لقد أسهم تقدم تقنيات المعالجة وتحسين شبكات المجاري في إمكانية استغلال هذا المصدر لأغراض الري والاستعمالات الصناعية وليس للاستهلاك البشري. وتغطي حوالي 21% من إجمالي احتياجات المياه بالمملكة. حيث وصل ما يستغل منها حاليا حوالي 286 مليون متر مكعب سنويا.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          'مياه البحر المحلاّه',
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.solidBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'تمتلك المملكة أكبر شبكة من محطات التحلية في العالم بقدرة إنتاجية تصل إلى حوالي 18% من إجمالي المياه المحلاة في العالم وتغذي أكثر من 40 مدينة ومحافظة وقرية بمياه الشرب والطاقة الكهربائية ومعدل إنتاج نحو 70% من احتياجات المياه بالمملكة ، وتعتبر هذه المياه حاليا المصدر الرئيس لمياه الشرب والأغراض المنزلية والصناعية. لقد ساعدت التكنولوجيا الحديثة على إمكانية الاستفادة من هذه المياه عن طريق محطات التحلية الحديثة ويبلغ عدد محطات التحلية بالمملكة 14 محطة منها 11 على الساحل الغربي وثلاثة على الشرقي، من أهم محطات الساحل الغربي محطة جدة، الشعيبة وينبع ومن أهم محطات الساحل الشرقي محطة الخبر والجبيل . تمتلك المملكة اليوم شبكة منظومات نقل مياه ضخمة تربط عدداً من المناطق ببعض تصل سعاتها إلى 12.5 مليون متر مكعب في اليوم، تبدأ شرقاً من سواحل الجبيل ورأس الخير لتصل إلى منطقة الرياض ومنها إلى منطقة القصيم ، وتزيد سعاتها على 3.3 مليون متر مكعب في اليوم. أما في الغرب فترتبط منطقة مكة المكرمة مع منطقة الباحة بشبكة نقل واحدة ويجري الإعداد لربطهما شمالا مع منطقة المدينة المنورة وجنوبا مع منطقتي عسير وجازان المرتبطتين بشبكة واحدة حالياً. وفي عام 2022م تم تدشين أكبر محطة عائمة لتحلية المياه في العالم، قرب ميناء الشقيق على الساحل الغربي للمملكة، تتمتع هذه المحطة بقدرة إنتاجية تبلغ 50 ألف متر مكعب من المياه يومياً، باستخدام تقنية التناضح العكسي.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          'التكوينات الرئيسية الحاملة للمياه',
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.solidBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'توجد المياه الجوفية في بعض التكوينات الجيولوجية التي تسمح فيها النفاذية والمسامية بمرور الماء وتخزينه في مسامات الصخور أو المواد الصخرية المفككة، وتسمح أيضاً بخروجه منها ودخوله إلى الآبار بكميات اقتصادية، وتسمى هذه التكوينات الجيولوجية بخزانات المياه الجوفية (AQUIFERS) التي قد تتكون من مواد صخرية مفككة مثل رواسب الأودية أو تتكون من صخور منفذة كالصخور الرملية. وتقسم خزانات المياه الجوفية وفقاً لعمق المياه الجوفية فيها إلى نوعين هما: خزانات المياه الجوفية الضحلة وخزانات المياه الجوفية العميقة كما تصنف خزانات المياه الجوفية إلى نوعين حسب ضغط الماء فيها، هما : الخزان الحر (Unconfined) في التكوين الجيولوجي الذي ينكشف على السطح ويقع إلى الأسفل منه تكوين غير منفذ، والخزان المحصور (Confined) في التكوين الجيولوجي الذي يقع بين تكوينين غير منفذين أحدهما يعلوه والآخر إلى الأسفل منه. وفي الغالب تكون خزانات المياه الجوفية العميقة من النوع المحصور. وبشكل عام تكون المياه الجوفية غير عميقة ومتجددة في الخزانات الحرة وتكون عميقة وغير متجددة (قديمة/حفرية (FOSSIL)) في الخزانات المحصورة.\n'
                        'تصنف تكوينات الصخور الرسوبية الحاملة للمياه في المملكة إلى خزانات رئيسية : الساق، تبوك، الوجيد، المنجور،البياض، الوسيع ، أم الرضمه، الدمام، النيوجين وأخرى ثانوية: الجوف ، برواث، الخف، الجله، ضرما، سكاكا والعرمه ، وتمتد منكشفات معظم تكوينات الصخور الروسوبية إلى مسافات طويلة قد تصل إلى أكثر من 1000 كيلو متر وقد يصل امتداد هذه الطبقات إلى عشرات الكيلومترات تحت السطح. تحتوي هذه الخزانات التي تتعاقب من الأقدم في الغرب إلى الأحدث في الشرق على مياه جوفية قديمة (غير متجددة) تختلف كمياتها باختلاف نوع صخور التكوين وسمكها وخواصها الهيدروليكية (النفاذية ومعامل التخزين) وفيما عدا الأجزاء المنكشفة من التكوينات الرسوبية فإن خزانات المياه فيها من النوع المحصور الذي تكون المياه فيه تحت ضغط إرتوازي.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(AppAssets.formationBrief, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(AppAssets.formation2, fit: BoxFit.contain),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
