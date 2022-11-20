
package com.indiagenisys.whatsapp_stickers_handler;

import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.database.Cursor;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

@SuppressWarnings("FieldCanBeLocal")
class WhitelistCheck {
    private static final String AUTHORITY_QUERY_PARAM = "authority";
    private static final String IDENTIFIER_QUERY_PARAM = "identifier";

    public static String CONSUMER_WHATSAPP_PACKAGE_NAME = "com.whatsapp";
    public static String SMB_WHATSAPP_PACKAGE_NAME = "com.whatsapp.w4b";
    private static String CONTENT_PROVIDER = ".provider.sticker_whitelist_check";
    private static String QUERY_PATH = "is_whitelisted";
    private static String QUERY_RESULT_COLUMN_NAME = "result";

    private static String TAG = "WhitelistCheck";

    static boolean isWhitelisted(@NonNull Context context, @NonNull String identifier) {
        try {
            if (!isWhatsAppConsumerAppInstalled(context.getPackageManager()) && !isWhatsAppSmbAppInstalled(context.getPackageManager())) {
                return false;
            }

            boolean consumerResult = isStickerPackWhitelistedInWhatsAppConsumer(context, identifier);
            boolean smbResult = isStickerPackWhitelistedInWhatsAppSmb(context, identifier);
            //Log.e("WHITELISTED", consumerResult + " " + smbResult);
            return consumerResult && smbResult;
        } catch (Exception e) {
            return false;
        }
    }

    static boolean isWhatsAppInstalled(@NonNull Context context) {
        try {
            return (isWhatsAppConsumerAppInstalled(context.getPackageManager()) || isWhatsAppSmbAppInstalled(context.getPackageManager()));
        } catch (Exception e) {
            return false;
        }
    }

    private static boolean isWhitelistedFromProvider(@NonNull Context context, @NonNull String identifier, String whatsappPackageName) {
        final PackageManager packageManager = context.getPackageManager();

        if (isPackageInstalled(whatsappPackageName, packageManager)) {
            final String whatsAppProviderAuthority = whatsappPackageName + CONTENT_PROVIDER;
            final ProviderInfo providerInfo = packageManager.resolveContentProvider(whatsAppProviderAuthority, PackageManager.GET_META_DATA);

            // provider is not there. The WhatsApp app may be an old version.
            if (providerInfo == null) {
                return false;
            }

            final Uri queryUri = new Uri.Builder().scheme(ContentResolver.SCHEME_CONTENT)
                    .authority(whatsAppProviderAuthority)
                    .appendPath(QUERY_PATH)
                    .appendQueryParameter(AUTHORITY_QUERY_PARAM, WhatsappStickersHandlerPlugin.getContentProviderAuthority(context))
                    .appendQueryParameter(IDENTIFIER_QUERY_PARAM, identifier).build();

            try (final Cursor cursor = context.getContentResolver().query(queryUri, null, null, null, null)) {
                if (cursor != null && cursor.moveToFirst()) {
                    final int whiteListResult = cursor.getInt(cursor.getColumnIndexOrThrow(QUERY_RESULT_COLUMN_NAME));

                    return whiteListResult == 1;
                }
            }
        } else {
            // if app is not installed, then don't need to take into its whitelist info into account.
            return true;
        }
        return false;
    }

    private static boolean isPackageInstalled(String packageName, PackageManager packageManager) {
        try {
            final ApplicationInfo applicationInfo = packageManager.getApplicationInfo(packageName, 0);

            //noinspection SimplifiableIfStatement
            return applicationInfo.enabled;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    static boolean isWhatsAppConsumerAppInstalled(PackageManager packageManager) {
        return WhitelistCheck.isPackageInstalled(CONSUMER_WHATSAPP_PACKAGE_NAME, packageManager);
    }

    static boolean isWhatsAppSmbAppInstalled(PackageManager packageManager) {
        return WhitelistCheck.isPackageInstalled(SMB_WHATSAPP_PACKAGE_NAME, packageManager);
    }

    static boolean isStickerPackWhitelistedInWhatsAppConsumer(@NonNull Context context, @NonNull String identifier) {
        return isWhitelistedFromProvider(context, identifier, CONSUMER_WHATSAPP_PACKAGE_NAME);
    }

    static boolean isStickerPackWhitelistedInWhatsAppSmb(@NonNull Context context, @NonNull String identifier) {
        return isWhitelistedFromProvider(context, identifier, SMB_WHATSAPP_PACKAGE_NAME);
    }
}