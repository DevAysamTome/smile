import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smileapp/providers/cart_provider.dart';
import 'package:smileapp/providers/orders_provider.dart';
import 'package:smileapp/screens/order_success.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // حقول النص للبيانات الشخصية
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  // حقل النص لعنوان التوصيل
  final TextEditingController _addressController = TextEditingController();

  int _currentStep = 0; // مؤشر الخطوة الحالية في الـStepper

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // دالة التحقق من البيانات في كل خطوة
  bool _validateStep(int step) {
    switch (step) {
      case 0:
        // تحقق من الاسم والهاتف
        if (_nameController.text.isEmpty) {
          _showError('يرجى إدخال الاسم');
          return false;
        }
        if (_phoneController.text.isEmpty) {
          _showError('يرجى إدخال رقم الهاتف');
          return false;
        }
        // يمكن إضافة تحقق إضافي لصحة رقم الهاتف
        return true;

      case 1:
        // تحقق من العنوان
        if (_addressController.text.isEmpty) {
          _showError('يرجى إدخال العنوان');
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  // دالة لعرض رسالة خطأ في حالة فشل التحقق
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // دالة للتنقل للخطوة التالية
  void _onStepContinue() {
    if (_validateStep(_currentStep)) {
      if (_currentStep < 1) {
        // إذا لم تكن في آخر خطوة، انتقل للخطوة التالية
        setState(() {
          _currentStep++;
        });
      } else {
        // إذا كنت في آخر خطوة (الخطوة الثانية)، نفذ منطق إرسال الطلب
        _submitOrder();
      }
    }
  }

  // دالة للرجوع خطوة واحدة للخلف
  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context); // إذا كنت في الخطوة الأولى، رجوع للشاشة السابقة
    }
  }

  // دالة تنفيذ الطلب
void _submitOrder() async {
    // جلب مزوّدي الطلبات والسلة
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // نفترض أنك تحققت من الحقول
    try {
      await ordersProvider.addOrder(
        cartProvider.items,
        cartProvider.totalAmount,
        _nameController.text,
        
        _phoneController.text,
        _addressController.text,

      );
print('عدد العناصر في السلة: ${cartProvider.items.length}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderSuccessScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إتمام الطلب: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إتمام الطلب'),
                backgroundColor: Colors.deepPurpleAccent[100],

        ),
        body: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          type: StepperType.vertical, // يمكن تغييره إلى StepperType.horizontal
          steps: _buildSteps(),
        ),
      ),
    );
  }

  // بناء الخطوات (Steps) الخاصة بالـStepper
  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('البيانات الشخصية'),
        content: _buildPersonalInfoForm(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('عنوان التوصيل'),
        content: _buildAddressForm(),
        isActive: _currentStep >= 1,
        state: _currentStep == 1 ? StepState.editing : StepState.indexed,
      ),
    ];
  }

  // النموذج الخاص بالبيانات الشخصية (الخطوة الأولى)
  Widget _buildPersonalInfoForm() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'الاسم'),
        ),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(labelText: 'رقم الهاتف'),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  // النموذج الخاص بعنوان التوصيل (الخطوة الثانية)
  Widget _buildAddressForm() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(labelText: 'العنوان'),
      maxLines: 2,
    );
  }
}
