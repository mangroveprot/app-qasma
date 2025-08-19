import 'user_cubit.dart';

import '../../data/models/user_model.dart';

extension UserSelectors on UserCubit {
  UserModel? getUserByIdNumber(String idNumber) {
    final s = state;
    if (s is UserLoadedState) {
      for (final u in s.users) {
        if (u.idNumber == idNumber) return u;
      }
    }
    return null;
  }
}
