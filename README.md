```bash
lib/
├── app.dart
├── main.dart

├── core/
│   ├── config/
│   ├── constants/
│   ├── error/
│   └── usecases/

├── common/
│   ├── error/
│   ├── network/
│   ├── storage/
│   ├── utils/
│   └── widgets/
│       └── button/
│           ├── custom_button.dart
│           ├── loading_button.dart
│           └── cubit/
│               └── button_cubit.dart

├── infrastructure/
│   ├── injection/
│   └── router/

├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/

├── theme/
└── l10n/

```
