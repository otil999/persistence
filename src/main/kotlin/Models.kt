package hu.otilsoft.catalog

import java.time.LocalDateTime
import javax.persistence.*


@MappedSuperclass
abstract class AbstractEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Long = 0L

    @Version
    val revision: Int = 0

    @Column(insertable = false, updatable = false)
    val created: LocalDateTime = LocalDateTime.now()
    var updated: LocalDateTime? = null
    var deleted: LocalDateTime? = null
}


@Entity(name = "storage_type")
data class StorageType(var name: String = "") : AbstractEntity()


@Entity
data class Genre(var name: String = "") : AbstractEntity()


@Entity
data class Series(
    var name: String = "",

    @OneToMany(mappedBy = "series", fetch = FetchType.LAZY, cascade = [CascadeType.ALL])
    var games: List<Game> = emptyList(),

    @OneToMany(mappedBy = "series", fetch = FetchType.LAZY, cascade = [CascadeType.ALL])
    var movies: List<Movie> = emptyList(),
) : AbstractEntity()


@Entity
data class Media(var name: String = "") : AbstractEntity()


@Entity
data class Storage(
    var name: String = "",

    @ManyToOne
    @JoinColumn(name = "storage_type_id", referencedColumnName = "id")
    var storageType: StorageType? = null
) : AbstractEntity()


@Entity
data class Movie(
    var name: String = "",

    @Column(name = "original_name")
    var originalName: String? = null,
    var link: String? = null,
    var release: Int? = null,
    var rating: Double? = null,
    var counter: Int = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    var media: Media? = null,

    @Column(name = "media_number")
    var mediaNumber: Int? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var storage: Storage? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var series: Series? = null,

    @Column(name = "series_num")
    var seriesNum: Int? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var genre: Genre? = null
) : AbstractEntity() {
    fun isBelongToSeries() = series != null
}


@Entity
data class Game(
    var name: String = "",
    var counter: Int = 0,
    var rating: Double? = null,
    var release: Int? = null,
    var link: String? = null,

    @ManyToOne
    var media: Media? = null,

    @ManyToOne(fetch = FetchType.LAZY)
    var storage: Storage? = null,

    @ManyToOne
    var series: Series? = null,

    @Column(name = "series_num")
    var seriesNum: Int? = null,

    @ManyToOne
    var genre: Genre? = null,

    @Column(name = "long_term")
    var longTerm: Boolean? = null,
    var description: String? = null
) : AbstractEntity() {
    fun isBelongToSeries() = series != null
}
