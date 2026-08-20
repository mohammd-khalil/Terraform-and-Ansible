# Terraform + GitHub Actions — EC2 Pipeline

## هيكل المشروع

```
terraform-ec2-pipeline/
├── bootstrap/              # يتشغّل مرة واحدة يدويًا لإنشاء الـ S3 bucket و DynamoDB table
│   └── main.tf
├── terraform/               # المشروع الأساسي (VPC + Subnet + SG + EC2)
│   ├── backend.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── security_group.tf
│   ├── ec2.tf
│   └── outputs.tf
└── .github/workflows/terraform.yml
```

## خطوات التشغيل

### 1) Bootstrap (مرة واحدة فقط)
الـ backend (S3 + DynamoDB) لازم يكون موجود قبل ما الـ `terraform/` يقدر يستخدمه، فبنعمله في مجلد منفصل بدون remote backend:

```bash
cd bootstrap
terraform init
terraform apply
```

### 2) إعداد GitHub Secrets
في إعدادات الـ repo على GitHub، ضيف:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 3) الـ Pipeline
أي push على `main` بيغيّر حاجة في `terraform/` هيشغّل الـ workflow تلقائيًا:
`fmt check → init → validate → plan → apply` (الـ apply بس على main).

## ملاحظات وتصحيحات مهمة

1. **الـ CIDR كان فيه مشكلة**: طلبت VPC بـ `172.16.0.0/24` و subnet بـ `127.16.1.0/24` (لاحظ الفرق: 127 بدل 172 — ده على الأغلب typo). كمان الـ `/24` بيدي 256 IP بس، يعني الـ VPC والـ subnet مش هيتسعوا لبعض. تم تصحيحها إلى:
   - VPC: `172.16.0.0/16`
   - Public Subnet: `172.16.1.0/24`
   
   لو قصدك فعلاً VPC صغير بـ `/24`، قولّي وهظبطهملك بحيث الـ subnet يبقى جزء أصغر منه (مثلاً `/26`).

2. **DynamoDB مش بيعمل تشفير للـ state file** — دوره الحقيقي هو الـ **state locking** (يمنع اتنين يشغلوا `apply` في نفس الوقت). التشفير (encryption) بيتم عن طريق `encrypt = true` في الـ backend + server-side encryption على الـ S3 bucket نفسه، وده مضبوط في `bootstrap/main.tf`.

3. الـ security group بيسمح SSH بس من `156.197.162.26/32`.

4. الـ EC2 مربوط بالـ public subnet ومعاه `map_public_ip_on_launch = true` عشان ياخد public IP.

## حاجات محتاجة تتأكد منها
- عايز key pair عشان تعمل SSH فعليًا؟ لو آه، محتاج تضيف `key_name` في `ec2.tf` وتتأكد إن الـ key موجود في نفس الـ region.
- مفيش IAM role مربوط بالـ instance حاليًا — لو محتاج الـ EC2 يوصل لخدمات AWS تانية (زي S3)، قولّي أضيفه.
- الـ instance type الافتراضي `t2.micro` (Free tier) — غيّره لو محتاج حجم مختلف.
>>>>>>> 55bf0ab (Building a pipeline to provision an infrastructure using terraform and make tests using snyk tool)
