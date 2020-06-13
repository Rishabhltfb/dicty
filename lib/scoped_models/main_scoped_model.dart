import 'package:dictyapp/scoped_models/dict_service.dart';
import 'package:dictyapp/scoped_models/lang_service.dart';
import 'package:dictyapp/scoped_models/user_model.dart';
import 'package:dictyapp/scoped_models/youtube_service.dart';
import 'package:scoped_model/scoped_model.dart';

import './connected_scoped_model.dart';

class MainModel extends Model
    with ConnectedModel, UserModel, LangService, DictService, YoutubeService {}
