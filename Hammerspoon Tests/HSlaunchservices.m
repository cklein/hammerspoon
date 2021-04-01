//
//  HSlaunchservices.m
//  Hammerspoon Tests
//
//  Created by Christian Klein on 2021-12-22.
//  Copyright © 2021 Hammerspoon. All rights reserved.
//

#import "HSTestCase.h"

@interface HSlaunchservices : HSTestCase

@end

@implementation HSlaunchservices

- (void)setUp {
  [super setUpWithRequire:@"test_launchservices"];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testRandomFloat {
  RUN_LUA_TEST()
}

- (void)testRandomFromRange {
  RUN_LUA_TEST()
}

@end
