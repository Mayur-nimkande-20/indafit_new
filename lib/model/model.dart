import 'package:hive/hive.dart';

part "model.g.dart";

/*@HiveType(typeId: 1)
class Data {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;

  Data({
    required this.title,
    required this.description,
  });
}*/

@HiveType(typeId: 1)
class ExerciseCategories{
  @HiveField(0)
  String name;
  @HiveField(1)
  String shortName;
  @HiveField(2)
  List<MovementModel> movements;
  ExerciseCategories({required this.name, required this.shortName, required this.movements});

  static ExerciseCategories fromJson(dynamic json) {
    final name = (json['name'] as String?)??'';
    final shortName = (json['shortName'] as String?)??'';
    final movements = (json['movements'] as List? ?? <MovementModel>[]).map<MovementModel>((v) => MovementModel.fromJson(v)).toList();

    /*if (json['movements'] != null) {
      movements = new List<MovementModel>();
      json['movements'].forEach((v) {
        movements.add(new MovementModel.fromJson(v));
      });
    }*/
    return ExerciseCategories(name: name,shortName:shortName, movements: movements);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['shortName'] = this.shortName;
    if (this.movements != null) {
      data['movements'] =
          this.movements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 2)
class MovementModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<ExerciseModel> sets;

  MovementModel({
    required this.name,
    required this.sets
  });
  static MovementModel fromJson(dynamic json) {
    final name = (json['name'] as String?)??'';
    final sets = (json['sets'] as List? ?? <ExerciseModel>[]).map<ExerciseModel>((v) => ExerciseModel.fromJson(v)).toList();
    /*if (json['sets'] != null) {
      sets = json['sets'].map<ExerciseModel>((v) => ExerciseModel.fromJson(v)).toList();
      /*sets = List<ExerciseModel>.empty();
      json['movements'].forEach((v) {
        sets.add(ExerciseModel.fromJson(v));
      });*/
    }*/
    return MovementModel(name: name, sets: sets);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.sets != null) {
      data['sets'] =
          this.sets.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 3)
class ExerciseModel {
  @HiveField(0)
  String set;
  @HiveField(1)
  String reps;
  @HiveField(2)
  String weight;
  @HiveField(3)
  String weightMode;
  @HiveField(4)
  String assistMode;

  ExerciseModel({
    required this.set,
    required this.reps,
    required this.weight,
    required this.weightMode,
    required this.assistMode
  });

  static ExerciseModel fromJson(dynamic json) {
    final set = (json['set'] as String?)??'';
    final reps = (json['reps'] as String?)??'';
    final weight = (json['weight'] as String?)??'';
    final weightMode = (json['weightMode'] as String?)??'';
    final assistMode = (json['assistMode'] as String?)??'';
    return ExerciseModel(set: set, reps: reps, weight: weight, weightMode: weightMode, assistMode: assistMode);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['set'] = set;
    data['reps'] = reps;
    data['weight'] = weight;
    data['weightMode'] = weightMode;
    data['assistMode'] = assistMode;
    return data;
  }
}

@HiveType(typeId: 4)
class UserModel {
  @HiveField(0)
  String firstName;
  @HiveField(1)
  String lastName;
  @HiveField(2)
  String userName;
  @HiveField(3)
  String passWord;
  @HiveField(4)
  String birthDate;
  @HiveField(5)
  String mobile;
  @HiveField(6)
  String email;
  @HiveField(7)
  String gender;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.passWord,
    required this.birthDate,
    required this.mobile,
    required this.email,
    required this.gender
  });
}
/*
import 'package:hive/hive.dart';

part 'hiveCoupler.g.dart';

@HiveType(typeId: 4)

class Coupler {
  @HiveField(0)
  int couplerTrackCaseId;
  @HiveField(1)
  int couplerTrackCaseTypeId;
  @HiveField(2)
  int couplerGroupId;
  @HiveField(3)
  String checklistRef;
  @HiveField(4)
  int totalCount;
  @HiveField(5)
  int currentProgressId;
  @HiveField(6)
  String firstConcretingPersonId;
  @HiveField(7)
  String firstConcretingPersonDate;
  @HiveField(8)
  String secondConcretingPersonId;
  @HiveField(9)
  String secondConcretingPersonDate;
  @HiveField(10)
  String rcCheckerPersonId;
  @HiveField(11)
  String rseCheckerPersonId;
  @HiveField(12)
  int locationId;
  @HiveField(13)
  CouplerGroup couplerGroup;
  @HiveField(14)
  List<CouplerTrackStageList> couplerTrackStageList;
  @HiveField(15)
  CurrentProgress currentProgress;
  @HiveField(16)
  LocationOfSite locationOfSite;
  @HiveField(17)
  List<CouplerTrackCaseReferenceList> couplerTrackCaseReferenceList;
  @HiveField(18)
  List<CouplerTrackCaseOrderNumberList> couplerTrackCaseOrderNumberList;
  @HiveField(19)
  List<CouplerTrackCaseArrivalList> couplerTrackCaseArrivalList;
  @HiveField(20)
  String checkingPersonRcName;
  @HiveField(21)
  int checkingPersonRcFrequency;
  @HiveField(22)
  String checkingPersonRseName;
  @HiveField(23)
  int checkingPersonRseFrequency;
  @HiveField(24)
  String orderNumber;
  @HiveField(25)
  String referenceDesc;
  @HiveField(26)
  String couplerTrackCaseArrivalDate;
  @HiveField(27)
  String checkingPersonRseGrade;
  @HiveField(28)
  String checkingPersonRcGrade;

  Coupler(
      {this.couplerTrackCaseId,
      this.couplerTrackCaseTypeId,
      this.couplerGroupId,
      this.checklistRef,
      this.totalCount,
      this.currentProgressId,
      this.firstConcretingPersonId,
      this.firstConcretingPersonDate,
      this.secondConcretingPersonId,
      this.secondConcretingPersonDate,
      this.rcCheckerPersonId,
      this.rseCheckerPersonId,
      this.locationId,
      this.couplerGroup,
      this.couplerTrackStageList,
      this.currentProgress,
      this.locationOfSite,
      this.couplerTrackCaseReferenceList,
      this.couplerTrackCaseOrderNumberList,
      this.couplerTrackCaseArrivalList,
      this.checkingPersonRcName,
      this.checkingPersonRcFrequency,
      this.checkingPersonRseName,
      this.checkingPersonRseFrequency,
      this.orderNumber,
      this.referenceDesc,
      this.couplerTrackCaseArrivalDate,
      this.checkingPersonRseGrade,
      this.checkingPersonRcGrade});

  Coupler.fromJson(Map<String, dynamic> json) {
    couplerTrackCaseId = json['couplerTrackCaseId'];
    couplerTrackCaseTypeId = json['couplerTrackCaseTypeId'];
    couplerGroupId = json['couplerGroupId'];
    checklistRef = json['checklistRef'];
    totalCount = json['totalCount'];
    currentProgressId = json['currentProgressId'];
    firstConcretingPersonId = json['firstConcretingPersonId'];
    firstConcretingPersonDate = json['firstConcretingPersonDate'];
    secondConcretingPersonId = json['secondConcretingPersonId'];
    secondConcretingPersonDate = json['secondConcretingPersonDate'];
    rcCheckerPersonId = json['rcCheckerPersonId'];
    rseCheckerPersonId = json['rseCheckerPersonId'];
    locationId = json['locationId'];
    couplerGroup = json['couplerGroup'] != null
        ? new CouplerGroup.fromJson(json['couplerGroup'])
        : null;
    if (json['couplerTrackStageList'] != null) {
      couplerTrackStageList = new List<CouplerTrackStageList>();
      json['couplerTrackStageList'].forEach((v) {
        couplerTrackStageList.add(new CouplerTrackStageList.fromJson(v));
      });
    }
    currentProgress = json['currentProgress'] != null
        ? new CurrentProgress.fromJson(json['currentProgress'])
        : null;
    locationOfSite = json['locationOfSite'] != null
        ? new LocationOfSite.fromJson(json['locationOfSite'])
        : null;
    if (json['couplerTrackCaseReferenceList'] != null) {
      couplerTrackCaseReferenceList = new List<CouplerTrackCaseReferenceList>();
      json['couplerTrackCaseReferenceList'].forEach((v) {
        couplerTrackCaseReferenceList
            .add(new CouplerTrackCaseReferenceList.fromJson(v));
      });
    }
    if (json['couplerTrackCaseOrderNumberList'] != null) {
      couplerTrackCaseOrderNumberList =
          new List<CouplerTrackCaseOrderNumberList>();
      json['couplerTrackCaseOrderNumberList'].forEach((v) {
        couplerTrackCaseOrderNumberList
            .add(new CouplerTrackCaseOrderNumberList.fromJson(v));
      });
    }
    if (json['couplerTrackCaseArrivalList'] != null) {
      couplerTrackCaseArrivalList = new List<CouplerTrackCaseArrivalList>();
      json['couplerTrackCaseArrivalList'].forEach((v) {
        couplerTrackCaseArrivalList
            .add(new CouplerTrackCaseArrivalList.fromJson(v));
      });
    }
    checkingPersonRcName = json['checkingPersonRcName'];
    checkingPersonRcFrequency = json['checkingPersonRcFrequency'];
    checkingPersonRseName = json['checkingPersonRseName'];
    checkingPersonRseFrequency = json['checkingPersonRseFrequency'];
    orderNumber = json['orderNumber'];
    referenceDesc = json['referenceDesc'];
    couplerTrackCaseArrivalDate = json['couplerTrackCaseArrivalDate'];
    checkingPersonRseGrade = json['checkingPersonRseGrade'];
    checkingPersonRcGrade = json['checkingPersonRcGrade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couplerTrackCaseId'] = this.couplerTrackCaseId;
    data['couplerTrackCaseTypeId'] = this.couplerTrackCaseTypeId;
    data['couplerGroupId'] = this.couplerGroupId;
    data['checklistRef'] = this.checklistRef;
    data['totalCount'] = this.totalCount;
    data['currentProgressId'] = this.currentProgressId;
    data['firstConcretingPersonId'] = this.firstConcretingPersonId;
    data['firstConcretingPersonDate'] = this.firstConcretingPersonDate;
    data['secondConcretingPersonId'] = this.secondConcretingPersonId;
    data['secondConcretingPersonDate'] = this.secondConcretingPersonDate;
    data['rcCheckerPersonId'] = this.rcCheckerPersonId;
    data['rseCheckerPersonId'] = this.rseCheckerPersonId;
    data['locationId'] = this.locationId;
    if (this.couplerGroup != null) {
      data['couplerGroup'] = this.couplerGroup.toJson();
    }
    if (this.couplerTrackStageList != null) {
      data['couplerTrackStageList'] =
          this.couplerTrackStageList.map((v) => v.toJson()).toList();
    }
    if (this.currentProgress != null) {
      data['currentProgress'] = this.currentProgress.toJson();
    }
    if (this.locationOfSite != null) {
      data['locationOfSite'] = this.locationOfSite.toJson();
    }
    if (this.couplerTrackCaseReferenceList != null) {
      data['couplerTrackCaseReferenceList'] =
          this.couplerTrackCaseReferenceList.map((v) => v.toJson()).toList();
    }
    if (this.couplerTrackCaseOrderNumberList != null) {
      data['couplerTrackCaseOrderNumberList'] =
          this.couplerTrackCaseOrderNumberList.map((v) => v.toJson()).toList();
    }
    if (this.couplerTrackCaseArrivalList != null) {
      data['couplerTrackCaseArrivalList'] =
          this.couplerTrackCaseArrivalList.map((v) => v.toJson()).toList();
    }
    data['checkingPersonRcName'] = this.checkingPersonRcName;
    data['checkingPersonRcFrequency'] = this.checkingPersonRcFrequency;
    data['checkingPersonRseName'] = this.checkingPersonRseName;
    data['checkingPersonRseFrequency'] = this.checkingPersonRseFrequency;
    data['orderNumber'] = this.orderNumber;
    data['referenceDesc'] = this.referenceDesc;
    data['couplerTrackCaseArrivalDate'] = this.couplerTrackCaseArrivalDate;
    data['checkingPersonRseGrade'] = this.checkingPersonRseGrade;
    data['checkingPersonRcGrade'] = this.checkingPersonRcGrade;
    return data;
  }
}

@HiveType(typeId: 5)
class CouplerGroup {
  int couplerGroupId;
  int couplerTypeId;
  String siteId;
  int towerId;
  int floorId;
  String groupDesc;
  int rebarSum;
  CouplerType couplerType;
  CouplerTrackCaseType couplerTrackCaseType;
  Site site;
  Tower tower;
  Floor floor;
  List<CouplerGroupRebarSetups> couplerGroupRebarSetups;
  List<CouplerGroupImages> couplerGroupImages;

  CouplerGroup(
      {this.couplerGroupId,
      this.couplerTypeId,
      this.siteId,
      this.towerId,
      this.floorId,
      this.groupDesc,
      this.rebarSum,
      this.couplerType,
      this.couplerTrackCaseType,
      this.site,
      this.tower,
      this.floor,
      this.couplerGroupRebarSetups,
      this.couplerGroupImages});

  CouplerGroup.fromJson(Map<String, dynamic> json) {
    couplerGroupId = json['couplerGroupId'];
    couplerTypeId = json['couplerTypeId'];
    siteId = json['siteId'];
    towerId = json['towerId'];
    floorId = json['floorId'];
    groupDesc = json['groupDesc'];
    rebarSum = json['rebarSum'];
    couplerType = json['couplerType'] != null
        ? new CouplerType.fromJson(json['couplerType'])
        : null;
    couplerTrackCaseType = json['couplerTrackCaseType'] != null
        ? new CouplerTrackCaseType.fromJson(json['couplerTrackCaseType'])
        : null;
    site = json['site'] != null ? new Site.fromJson(json['site']) : null;
    tower = json['tower'] != null ? new Tower.fromJson(json['tower']) : null;
    floor = json['floor'] != null ? new Floor.fromJson(json['floor']) : null;
    if (json['couplerGroupRebarSetups'] != null) {
      couplerGroupRebarSetups = new List<CouplerGroupRebarSetups>();
      json['couplerGroupRebarSetups'].forEach((v) {
        couplerGroupRebarSetups.add(new CouplerGroupRebarSetups.fromJson(v));
      });
    }
    if (json['couplerGroupImages'] != null) {
      couplerGroupImages = new List<CouplerGroupImages>();
      json['couplerGroupImages'].forEach((v) {
        couplerGroupImages.add(new CouplerGroupImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couplerGroupId'] = this.couplerGroupId;
    data['couplerTypeId'] = this.couplerTypeId;
    data['siteId'] = this.siteId;
    data['towerId'] = this.towerId;
    data['floorId'] = this.floorId;
    data['groupDesc'] = this.groupDesc;
    data['rebarSum'] = this.rebarSum;
    if (this.couplerType != null) {
      data['couplerType'] = this.couplerType.toJson();
    }
    if (this.couplerTrackCaseType != null) {
      data['couplerTrackCaseType'] = this.couplerTrackCaseType.toJson();
    }
    if (this.site != null) {
      data['site'] = this.site.toJson();
    }
    if (this.tower != null) {
      data['tower'] = this.tower.toJson();
    }
    if (this.floor != null) {
      data['floor'] = this.floor.toJson();
    }
    if (this.couplerGroupRebarSetups != null) {
      data['couplerGroupRebarSetups'] =
          this.couplerGroupRebarSetups.map((v) => v.toJson()).toList();
    }
    if (this.couplerGroupImages != null) {
      data['couplerGroupImages'] =
          this.couplerGroupImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 6)
class CouplerType {
  int couplerTypeId;
  int couplerTrackCaseTypeId;
  String couplerTypeDesc;
  double rcInspectFrequency;
  double rseInspectFrequency;

  CouplerType(
      {this.couplerTypeId,
      this.couplerTrackCaseTypeId,
      this.couplerTypeDesc,
      this.rcInspectFrequency,
      this.rseInspectFrequency});

  CouplerType.fromJson(Map<String, dynamic> json) {
    couplerTypeId = json['couplerTypeId'];
    couplerTrackCaseTypeId = json['couplerTrackCaseTypeId'];
    couplerTypeDesc = json['couplerTypeDesc'];
    rcInspectFrequency = json['rcInspectFrequency'];
    rseInspectFrequency = json['rseInspectFrequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couplerTypeId'] = this.couplerTypeId;
    data['couplerTrackCaseTypeId'] = this.couplerTrackCaseTypeId;
    data['couplerTypeDesc'] = this.couplerTypeDesc;
    data['rcInspectFrequency'] = this.rcInspectFrequency;
    data['rseInspectFrequency'] = this.rseInspectFrequency;
    return data;
  }
}

@HiveType(typeId: 7)
class CouplerTrackCaseType {
  int couplerTrackCaseTypeId;
  String caseTypeDesc;

  CouplerTrackCaseType({this.couplerTrackCaseTypeId, this.caseTypeDesc});

  CouplerTrackCaseType.fromJson(Map<String, dynamic> json) {
    couplerTrackCaseTypeId = json['couplerTrackCaseTypeId'];
    caseTypeDesc = json['caseTypeDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couplerTrackCaseTypeId'] = this.couplerTrackCaseTypeId;
    data['caseTypeDesc'] = this.caseTypeDesc;
    return data;
  }
}

@HiveType(typeId: 8)
class Site {
  String siteId;
  String siteDesc;
  String handGeometry;
  String teamId;
  String contractNo;
  String startDate;
  String contractTypeId;
  String companyId;
  String parentSiteId;
  String handkeyMifare;
  String archived;
  String projectName;
  String isDegrade;

  Site(
      {this.siteId,
      this.siteDesc,
      this.handGeometry,
      this.teamId,
      this.contractNo,
      this.startDate,
      this.contractTypeId,
      this.companyId,
      this.parentSiteId,
      this.handkeyMifare,
      this.archived,
      this.projectName,
      this.isDegrade});

  Site.fromJson(Map<String, dynamic> json) {
    siteId = json['siteId'];
    siteDesc = json['siteDesc'];
    handGeometry = json['handGeometry'];
    teamId = json['teamId'];
    contractNo = json['contractNo'];
    startDate = json['startDate'];
    contractTypeId = json['contractTypeId'];
    companyId = json['companyId'];
    parentSiteId = json['parentSiteId'];
    handkeyMifare = json['handkeyMifare'];
    archived = json['archived'];
    projectName = json['projectName'];
    isDegrade = json['isDegrade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteId'] = this.siteId;
    data['siteDesc'] = this.siteDesc;
    data['handGeometry'] = this.handGeometry;
    data['teamId'] = this.teamId;
    data['contractNo'] = this.contractNo;
    data['startDate'] = this.startDate;
    data['contractTypeId'] = this.contractTypeId;
    data['companyId'] = this.companyId;
    data['parentSiteId'] = this.parentSiteId;
    data['handkeyMifare'] = this.handkeyMifare;
    data['archived'] = this.archived;
    data['projectName'] = this.projectName;
    data['isDegrade'] = this.isDegrade;
    return data;
  }
}

@HiveType(typeId: 9)
class Tower {
  int towerId;
  String towerDesc;
  String enable;
  String towerShortName;
  String towerDescStr;

  Tower(
      {this.towerId,
      this.towerDesc,
      this.enable,
      this.towerShortName,
      this.towerDescStr});

  Tower.fromJson(Map<String, dynamic> json) {
    towerId = json['towerId'];
    towerDesc = json['towerDesc'];
    enable = json['enable'];
    towerShortName = json['towerShortName'];
    towerDescStr = json['towerDescStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['towerId'] = this.towerId;
    data['towerDesc'] = this.towerDesc;
    data['enable'] = this.enable;
    data['towerShortName'] = this.towerShortName;
    data['towerDescStr'] = this.towerDescStr;
    return data;
  }
}

@HiveType(typeId: 10)
class Floor {
  int floorId;
  String floorDesc;
  String enable;
  String floorShortName;
  String floorDescStr;

  Floor(
      {this.floorId,
      this.floorDesc,
      this.enable,
      this.floorShortName,
      this.floorDescStr});

  Floor.fromJson(Map<String, dynamic> json) {
    floorId = json['floorId'];
    floorDesc = json['floorDesc'];
    enable = json['enable'];
    floorShortName = json['floorShortName'];
    floorDescStr = json['floorDescStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['floorId'] = this.floorId;
    data['floorDesc'] = this.floorDesc;
    data['enable'] = this.enable;
    data['floorShortName'] = this.floorShortName;
    data['floorDescStr'] = this.floorDescStr;
    return data;
  }
}

@HiveType(typeId: 11)
class CouplerGroupRebarSetups {
  int couplerGroupRebarSetupId;
  int couplerGroupId;
  int referenceRebarFrom;
  int referenceRebarTo;
  String referenceDesc;
  String rebarDesc;
  String flagMultiple;
  List<CouplerGroupRebars> couplerGroupRebars;

  CouplerGroupRebarSetups(
      {this.couplerGroupRebarSetupId,
      this.couplerGroupId,
      this.referenceRebarFrom,
      this.referenceRebarTo,
      this.referenceDesc,
      this.rebarDesc,
      this.flagMultiple,
      this.couplerGroupRebars});

  CouplerGroupRebarSetups.fromJson(Map<String, dynamic> json) {
    couplerGroupRebarSetupId = json['couplerGroupRebarSetupId'];
    couplerGroupId = json['couplerGroupId'];
    referenceRebarFrom = json['referenceRebarFrom'];
    referenceRebarTo = json['referenceRebarTo'];
    referenceDesc = json['referenceDesc'];
    rebarDesc = json['rebarDesc'];
    flagMultiple = json['flagMultiple'];
    if (json['couplerGroupRebars'] != null) {
      couplerGroupRebars = new List<CouplerGroupRebars>();
      json['couplerGroupRebars'].forEach((v) {
        couplerGroupRebars.add(new CouplerGroupRebars.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couplerGroupRebarSetupId'] = this.couplerGroupRebarSetupId;
    data['couplerGroupId'] = this.couplerGroupId;
    data['referenceRebarFrom'] = this.referenceRebarFrom;
    data['referenceRebarTo'] = this.referenceRebarTo;
    data['referenceDesc'] = this.referenceDesc;
    data['rebarDesc'] = this.rebarDesc;
    data['flagMultiple'] = this.flagMultiple;
    if (this.couplerGroupRebars != null) {
      data['couplerGroupRebars'] =
          this.couplerGroupRebars.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
 */