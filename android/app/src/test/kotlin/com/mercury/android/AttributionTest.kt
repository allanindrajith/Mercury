package com.mercury.android

import org.junit.Assert.assertEquals
import org.junit.Test

class AttributionTest {
    @Test fun nameAndRepoMatchPermission() {
        assertEquals("Mercury for Android", Attribution.APP_NAME)
        assertEquals("https://github.com/allanindrajith/Mercury", Attribution.REPO_URL)
    }
}
