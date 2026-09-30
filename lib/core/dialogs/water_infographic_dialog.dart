import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';

class WaterInfographicDialog extends StatelessWidget {
  const WaterInfographicDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const WaterInfographicDialog(),
    );
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
            image: const DecorationImage(
              image: AssetImage(AppAssets.infoback),
              fit: BoxFit.cover,
            ),
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
                        'العيون: تضم المملكة العديد من العيون المائيَّة، والتي تُعد مصدراً للمياه السطحيّة، إذ تمّ تدفقها بشكل طبيعي دون تدخُّل من باطن الأرض وتنقسم إلى مياه عذبة صالحة للشرب وللاستخدام البشريّ، ومياه كبريتيّة حارّة صالحة للاستعمال العلاجيّ.',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 17,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 10 Infographics
                      const Center(
                        child: Text(
                          'لوحات ومخططات مصادر ومشاكل المياه',
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.solidBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      for (int i = 1; i <= 10; i++) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              AppAssets.waterProblem(i),
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ],
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
