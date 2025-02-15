import 'package:firebase_auth/firebase_auth.dart';
import 'package:fusecash/common/di/di.dart';
import 'package:fusecash/common/router/routes.gr.dart';
import 'package:fusecash/constants/urls.dart';
import 'package:fusecash/services/apis/explorer.dart';
import 'package:fusecash/services/apis/fuseswap.dart';
import 'package:fusecash/utils/onboard/Istrategy.dart';
import 'package:phone_number/phone_number.dart';
import 'package:wallet_core/wallet_core.dart';

final RootRouter rootRouter = getIt<RootRouter>();

final Explorer fuseExplorerApi = getIt<Explorer>(
  param1: UrlConstants.FUSE_EXPLORER_URL,
);

final API api = getIt<API>();

final WalletApi walletApi = getIt<WalletApi>();

final FuseSwapService fuseSwapService = getIt<FuseSwapService>();

final Graph graph = getIt<Graph>();

final FirebaseAuth firebaseAuth = getIt<FirebaseAuth>();

final PhoneNumberUtil phoneNumberUtil = getIt<PhoneNumberUtil>();

final IOnBoardStrategy onBoardStrategy = getIt<IOnBoardStrategy>();
