#import <Foundation/Foundation.h>
#import <LuaSkin/LuaSkin.h>

typedef void (^openHandler)(NSRunningApplication * _Nullable app, NSError * _Nullable error);

static int launchservices_open_url(lua_State* L) {
    LuaSkin *skin = [LuaSkin sharedWithState:L];
    [skin checkArgs:LS_TSTRING, LS_TBREAK | LS_TVARARG];

    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSURL *url = [NSURL fileURLWithPath:[skin toNSObjectAtIndex:1]];
    return (int)[workspace openURL:url];
}

static int launchservices_open_with_app_and_config(lua_State* L) {
    LuaSkin *skin = [LuaSkin sharedWithState:L];
    [skin checkArgs:LS_TSTRING, LS_TSTRING, LS_TTABLE|LS_TNIL|LS_TOPTIONAL, LS_TTABLE|LS_TNIL|LS_TOPTIONAL, LS_TBREAK];

    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSURL *url = [NSURL fileURLWithPath:[skin toNSObjectAtIndex:1]];
    NSArray<NSURL *> *urls = [NSArray<NSURL *> arrayWithObject:url];
    NSURL *appURL = [NSURL fileURLWithPath:[skin toNSObjectAtIndex:2]];

    id args = [skin toNSObjectAtIndex:3];
    if(args == nil || ![args isKindOfClass:[NSArray class]]) {
        args = [NSArray array];
    }

    id env = [skin toNSObjectAtIndex:4];
    if(env == nil || ![args isKindOfClass:[NSDictionary class]]) {
        env = [NSDictionary dictionary];
    }

    openHandler handler = ^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        if(error != nil) {
            [skin logError:[NSString stringWithFormat:@"Error opening %@: %@", url, error]];
        }
        if(app != nil) {
            [skin logInfo:[NSString stringWithFormat:@"Opened url %@ in app %@ (%@)", [url filePathURL], [app localizedName], [app bundleURL]]];
        }
    };

// Uncomment for manually tsting the pre-10.15 behaviour.
#if 0
    if (@available(macOS 10.15, *)) {
        NSLog(@"macOS 10.15 or above");
        NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration configuration];
        configuration.arguments = [NSArray<NSString *> array];
        configuration.environment = [NSDictionary<NSString *,NSString *> dictionary];
        [workspace
            openURLs:urls
            withApplicationAtURL:appURL
            configuration:configuration
            // TODO: Running handler crashes with GRAVE BUG: LUA EXECUTION ON NON_MAIN THREAD
            completionHandler:nil
        ];
    } else {
#endif
    if(1) {
        NSLog(@"Below macOS 10.15");
        NSMutableArray<NSWorkspaceLaunchConfigurationKey> *keys = [NSMutableArray<NSWorkspaceLaunchConfigurationKey> arrayWithObjects: NSWorkspaceLaunchConfigurationArguments, NSWorkspaceLaunchConfigurationEnvironment, nil];
        NSMutableArray *objects = [NSMutableArray arrayWithObjects: args, env, nil];
        NSDictionary<NSWorkspaceLaunchConfigurationKey,id> *configuration = [NSDictionary<NSWorkspaceLaunchConfigurationKey,id> dictionaryWithObjects:objects forKeys:keys];

        NSError *error = nil;
        NSRunningApplication *app = [workspace
            openURLs:urls
            withApplicationAtURL:appURL
            options:NSWorkspaceLaunchDefault
            configuration:configuration
            error:&error
        ];
        handler(app, error);
    }
    return 0;
}

// Functions for returned object when module loads
static const luaL_Reg launchservicesLib[] = {
    {"_open",  launchservices_open_url},
    {"_openWithAppAndConfig",  launchservices_open_with_app_and_config},
    {NULL, NULL}
};

int luaopen_hs_liblaunchservices(lua_State* L) {
    LuaSkin *skin = [LuaSkin sharedWithState:L];
    [skin registerLibrary:"hs.launchservices" functions:launchservicesLib metaFunctions:nil];
    return 1;
}
