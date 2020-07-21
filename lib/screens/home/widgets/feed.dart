import 'package:flutter_redux/flutter_redux.dart';
import 'package:fusecash/generated/i18n.dart';
import 'package:fusecash/models/transactions/transaction.dart';
import 'package:fusecash/models/transactions/transfer.dart';
import 'package:fusecash/models/app_state.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:fusecash/models/views/home.dart';
import 'package:fusecash/screens/home/widgets/transaction_tile.dart';

class Feed extends StatefulWidget {
  Feed({this.withTitle = true});
  final bool withTitle;
  @override
  createState() => new FeedState();
}

class FeedState extends State<Feed> {
  FeedState();

  @override
  void initState() {
    super.initState();
  }

  void onChange(HomeViewModel viewModel, BuildContext context) async {
    viewModel.setIdentifier();
    viewModel.startProcessingJobs();
    viewModel.startTransfersFetching();
    viewModel.listenToBranch();
    if (viewModel.isoCode == null) {
      Locale myLocale = Localizations.localeOf(context);
      Map localeData = codes.firstWhere(
          (Map code) => code['code'] == myLocale.countryCode,
          orElse: () => null);
      viewModel.setCountyCode(CountryCode(
          dialCode: localeData['dial_code'], code: localeData['code']));
    }
    if (!viewModel.isCommunityLoading &&
        viewModel.branchAddress != null &&
        viewModel.branchAddress != "" &&
        viewModel.walletAddress != '') {
      viewModel.branchCommunityUpdate();
    }
    if (!viewModel.isCommunityLoading &&
        !viewModel.isCommunityFetched &&
        viewModel.isBranchDataReceived &&
        viewModel.walletAddress != '') {
      viewModel.switchCommunity(viewModel.communityAddress);
    }
  }

  @override
  Widget build(BuildContext _context) {
    return new StoreConnector<AppState, HomeViewModel>(
        distinct: true,
        converter: HomeViewModel.fromStore,
        onInitialBuild: (viewModel) {
          onChange(viewModel, context);
        },
        onWillChange: (prevViewModel, nextViewModel) {
          onChange(nextViewModel, context);
        },
        builder: (_, viewModel) {
          final bool isWalletCreated = 'created' == viewModel.walletStatus;
          final Transfer generateWallet = new Transfer(
              type: 'RECEIVE',
              text: !isWalletCreated
                  ? I18n.of(context).generating_wallet
                  : I18n.of(context).generated_wallet,
              status: !isWalletCreated ? 'PENDING' : 'CONFIRMED',
              jobId: 'generateWallet');
          final List<Transaction> feedList = [
            ...viewModel.feedList,
            generateWallet,
          ];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.withTitle
                  ? Container(
                      padding: EdgeInsets.only(left: 15, top: 20),
                      child: Text(I18n.of(context).transactions,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal)))
                  : SizedBox.shrink(),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    itemCount: feedList?.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return TransactionTile(transfer: feedList[index]);
                    }),
              )
            ],
          );
        });
  }
}
