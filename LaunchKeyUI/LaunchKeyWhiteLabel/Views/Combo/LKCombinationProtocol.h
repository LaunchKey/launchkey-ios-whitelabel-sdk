//
//  LKCombinationProtocol.h
//  CombinationLock
//
//  Created by Kristin Tomasik on 3/4/13.
//  Copyright (c) 2013 LaunchKey, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LKCombinationProtocol <NSObject>

- (void) firstComboSet;
- (void) invalidShortComboSet;
- (void) invalidLongComboSet;
- (void) comboValid;
- (void) combosDoNotMatch;
- (void) comboDismissed;
- (void) comboUnlockedWithCircleCode:(NSArray*)circleCode;
- (void) comboSetAndDismissedWithCircleCode:(NSArray*)circleCode;
@end
