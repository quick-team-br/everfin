import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import dev.gitlive.firebase.Firebase
import dev.gitlive.firebase.firestore.firestore
import org.jetbrains.compose.ui.tooling.preview.Preview

suspend fun getItems(): List<Item> {
    val firebaseFirestore = Firebase.firestore
    try {
        val response =
            firebaseFirestore.collection("items").get()
        return response.documents.map {
            it.data()
        }
    } catch (e: Exception) {
        throw e
    }
}

@Composable
fun ItemRow(item: Item) {
    Row {
        Text(
            text = item.name
        )
        Text(
            text = item.value.toString()
        )
    }
}

@Composable
@Preview
fun App() {
    MaterialTheme {
        Column(Modifier.fillMaxWidth()) {
            var list by remember { mutableStateOf(listOf<Item>()) }
            LaunchedEffect(Unit) {
                list = getItems()
            }
            LazyRow {
                items(list) {
                    ItemRow(it)
                }
            }
        }
    }
}