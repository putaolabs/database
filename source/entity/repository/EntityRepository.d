/*
 * Entity - Entity is an object-relational mapping tool for the D programming language. Referring to the design idea of JPA.
 *
 * Copyright (C) 2015-2018  Shanghai Putao Technology Co., Ltd
 *
 * Developer: HuntLabs.cn
 *
 * Licensed under the Apache-2.0 License.
 *
 */
 
module entity.repository.EntityRepository;

import entity.repository.CrudRepository;
public import entity.domain;

class EntityRepository (T, ID) : CrudRepository!(T, ID)
{

	static string tableName()
	{
		return getUDAs!(getSymbolsByUDA!(T, Table)[0], Table)[0].name;
	}


	static string init_code()
	{
		return `		auto em = this.createEntityManager();
		CriteriaBuilder builder = em.getCriteriaBuilder();	
		auto criteriaQuery = builder.createQuery!T;
		Root!T root = criteriaQuery.from();`;
	}


	long count(Specification!T specification)
	{
		mixin(init_code);

		criteriaQuery.select(builder.count(root)).where(specification.toPredicate(
				root , criteriaQuery , builder));
		
		Long result = cast(Long)(em.createQuery(criteriaQuery).getSingleResult());
		em.close();
		return result.longValue();
	}

	T[] findAll(Sort sort)
	{
		mixin(init_code);

		//sort
		foreach(o ; sort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~ "." ~ o.getColumn() , o.getOrderType());

		//all
		criteriaQuery.select(root);

		TypedQuery!T typedQuery = em.createQuery(criteriaQuery);
		auto res = typedQuery.getResultList();
		em.close();
		return res;
	}


	T[] findAll(Specification!T specification)
	{
		mixin(init_code);

		//specification
		criteriaQuery.select(root).where(specification.toPredicate(
				root , criteriaQuery , builder));

		TypedQuery!T typedQuery = em.createQuery(criteriaQuery);
		auto res = typedQuery.getResultList();
		em.close();
		return res;
	}

	T[] findAll(Specification!T specification , Sort sort)
	{
		mixin(init_code);

		//sort
		foreach(o ; sort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~ "." ~ o.getColumn() , o.getOrderType());

		//specification
		criteriaQuery.select(root).where(specification.toPredicate(
				root , criteriaQuery , builder));

		TypedQuery!T typedQuery = em.createQuery(criteriaQuery);
		auto res = typedQuery.getResultList();
		em.close();
		return res;
	}


	Page!T findAll(Pageable pageable)
	{
		mixin(init_code);

		//sort
		foreach(o ; pageable.getSort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~ "." ~ o.getColumn() , o.getOrderType());

		//all
		criteriaQuery.select(root);

		//page
		TypedQuery!T typedQuery = em.createQuery(criteriaQuery).setFirstResult(pageable.getOffset())
				.setMaxResults(pageable.getPageSize());
		auto res = typedQuery.getResultList();
		auto page = new Page!T(res , pageable , super.count());
		em.close();
		return page;
	}

	Page!T findAll(Specification!T specification, Pageable pageable)
	{
		mixin(init_code);

		//sort
		foreach(o ; pageable.getSort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~"." ~ o.getColumn() , o.getOrderType());

		//specification
		criteriaQuery.select(root).where(specification.toPredicate(
				root , criteriaQuery , builder));
				
		//page
		TypedQuery!T typedQuery = em.createQuery(criteriaQuery).setFirstResult(pageable.getOffset())
			.setMaxResults(pageable.getPageSize());
		auto res = typedQuery.getResultList();
		auto page = new Page!T(res , pageable , count(specification));
		em.close();
		return page;
	}

}