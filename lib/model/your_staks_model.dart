class yourStaksModel {
  int? index;
  BigInt? amount;
  BigInt? claimedApr;
  BigInt? startTime;
  BigInt? endTime;
  BigInt? lastWithdrawTime;
  BigInt? percentPerInterval;
  BigInt? lockupTime;
  bool? isClaimed;
  bool? isActive;
  BigInt? claimReward;
  bool viewStaking=false;
  yourStaksModel(
      {this.index,
        this.amount,
        this.claimedApr,
        this.startTime,
        this.endTime,
        this.lastWithdrawTime,
        this.percentPerInterval,
        this.lockupTime,
        this.isClaimed,
        this.isActive,
      this.claimReward,
        this.viewStaking=false
      });

  yourStaksModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    amount = json['amount'];
    claimedApr = json['claimedApr'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    lastWithdrawTime = json['lastWithdrawTime'];
    percentPerInterval = json['percentPerInterval'];
    lockupTime = json['lockupTime'];
    isClaimed = json['isClaimed'];
    isActive = json['isActive'];
    claimReward=json["claimReward"];
    viewStaking=json["viewStaking"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['amount'] = this.amount;
    data['claimedApr'] = this.claimedApr;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['lastWithdrawTime'] = this.lastWithdrawTime;
    data['percentPerInterval'] = this.percentPerInterval;
    data['lockupTime'] = this.lockupTime;
    data['isClaimed'] = this.isClaimed;
    data['isActive'] = this.isActive;
    return data;
  }
}