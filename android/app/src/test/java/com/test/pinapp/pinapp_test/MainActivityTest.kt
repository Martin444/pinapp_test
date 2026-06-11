package com.test.pinapp.pinapp_test

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.net.HttpURLConnection
import java.net.URL

class MainActivityTest {

    @Test
    fun urlConstruction() {
        val postId = 1
        val url = URL("https://jsonplaceholder.typicode.com/comments?postId=$postId")
        assertEquals("https://jsonplaceholder.typicode.com/comments?postId=1", url.toString())
    }

    @Test
    fun urlConstructionWithLargePostId() {
        val postId = 99999
        val url = URL("https://jsonplaceholder.typicode.com/comments?postId=$postId")
        assertTrue(url.toString().contains("postId=99999"))
    }

    @Test
    fun httpOkConstant() {
        assertEquals(200, HttpURLConnection.HTTP_OK)
    }

    @Test
    fun successStatusCodeRange() {
        val codes = listOf(200, 201, 204, 299)
        codes.forEach { code ->
            assertTrue("$code should be success", code in 200..299)
        }
    }

    @Test
    fun errorStatusCodeRange() {
        val codes = listOf(100, 300, 400, 404, 500, 503)
        codes.forEach { code ->
            assertTrue("$code should be error", code !in 200..299)
        }
    }
}
