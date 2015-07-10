//
//  CBConstants.h
//  CleanBasketDeliver
//
//  Created by 강한용 on 2015. 6. 27..
//  Copyright (c) 2015년 강한용. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBConstants : NSObject

typedef enum serverConstant : NSUInteger {
    CBServerConstantSessionExpired = 0,
    CBServerConstantSuccess,
    CBServerConstantError,
    CBServerConstantEmailError,
    CBServerConstantPasswordError,
    CBServerConstantAccountValid,
    CBServerConstantAccountInvalid = 6,
    CBServerConstantAccountEnabled = 8,
    CBServerConstantAccountDisabled,
    
    CBServerConstantsRoleAdmin = 10,
    CBServerConstantsRoleDeliverer,
    CBServerConstantsRoleMember,
    CBServerConstantsRoleInvalid,
    CBServerConstantsImageWriteError,
    CBServerConstantsImpossible,
    CBServerConstantsAccountDuplication,
    CBServerConstantsSessionValid = 17,
    
    CBServerConstantsPushAssignPickup = 100,
    CBServerConstantsPushAssignDropoff,
    CBServerConstantsPushSoonPickup,
    CBServerConstantsPushSoonDropoff = 103,
    
    CBServerConstantsPushOrderAdd = 200,
    CBServerConstantsPushOrderCancel,
    CBServerConstantsPushPickupComplete,
    CBServerConstantsPushDropoffComplete,
    CBServerConstantsPushMemberJoin,
    CBServerConstantsPushDelivererJoin,
    CBServerConstantsPushChangeAccountEnabled = 206,
    
    CBServerConstantsDuplication = 207,
    CBServerConstantsInvalid = 208
} ServerContant ;

@end
